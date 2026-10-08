#!/bin/zsh -f
# Run with /bin/zsh -f plugins/ollama/tests/run.zsh.
# The child shell presses Tab using ZLE; it never submits an Ollama command.
emulate -LR zsh
setopt extendedglob
zmodload zsh/zpty || exit 1
zmodload zsh/zselect || exit 1

readonly test_dir=${0:A:h}
readonly plugin_dir=${test_dir:h}
readonly scratch=$(mktemp -d "${TMPDIR:-/tmp}/ollama-completion.XXXXXXXX") \
  || exit 1
integer passed=0 failed=0

cleanup() {
  zpty -d ollama-test 2>/dev/null
  command rm -rf -- "$scratch"
}
trap cleanup EXIT INT TERM
command mkdir -p "$scratch/bin" "$scratch/no-jq" "$scratch/cache" \
  "$scratch/empty"
print -r -- 'FROM qwen3.5:4b' > "$scratch/empty/Modelfile"
command cp "$test_dir/mock-curl.zsh" "$scratch/bin/curl"
command cp "$test_dir/mock-ollama.zsh" "$scratch/bin/ollama"
command chmod +x "$scratch/bin/curl" "$scratch/bin/ollama"
command ln -s "$scratch/bin/curl" "$scratch/no-jq/curl"
command ln -s "$scratch/bin/ollama" "$scratch/no-jq/ollama"
command ln -s /bin/cat "$scratch/no-jq/cat"
command ln -s /usr/bin/awk "$scratch/no-jq/awk"
export OLLAMA_TEST_FIXTURES="$test_dir/fixtures"
export OLLAMA_TEST_CALLS="$scratch/calls"
export OLLAMA_TEST_REQUESTS="$scratch/requests"
export OLLAMA_TEST_PLUGIN="$plugin_dir"
export OLLAMA_TEST_SCRATCH="$scratch"

cat > "$scratch/setup.zsh" <<'SETUP'
PATH="$OLLAMA_TEST_SCRATCH/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin"
OLLAMA_TEST_ORIGINAL_PATH=$PATH
XDG_CACHE_HOME="$OLLAMA_TEST_SCRATCH/cache"
TERM=xterm
PROMPT='TEST> '
RPROMPT=''
cd "$OLLAMA_TEST_SCRATCH/empty"
fpath=("$OLLAMA_TEST_PLUGIN" $fpath)
autoload -Uz compinit
compinit -D
zstyle ':completion:*' menu no
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' metadata-url https://metadata.test
unsetopt automenu menucomplete
setopt autolist listambiguous
_test_dump_buffer() {
  print -r -- "<<<BUFFER=$BUFFER>>>"
  print -r -- '<<<END>>>'
  zle redisplay
}
zle -N _test_dump_buffer
bindkey '^I' complete-word
bindkey '^X^N' menu-complete
bindkey '^X^B' _test_dump_buffer
print -r -- '<<<READY>>>'
SETUP

# A user's exported FPATH may point at another Zsh installation's functions.
zpty -b ollama-test env -u FPATH /bin/zsh -dfi
zpty -w ollama-test "source ${(q)scratch}/setup.zsh"

# Nonblocking reads keep a failed child or completion from hanging the suite.
read_until() {
  local sentinel=$1 chunk
  REPLY=''
  integer tries=0
  while (( ++tries <= 500 )); do
    if zpty -r ollama-test chunk; then
      REPLY+=$chunk
      [[ $REPLY == *$sentinel* ]] && return 0
    else
      zselect -t 1
    fi
  done
  print -u2 -r -- "Timed out waiting for $sentinel: ${(qqq)REPLY}"
  return 1
}
read_until '<<<READY>>>' || exit 1

complete_line() {
  local line=$1 tabs=${2:-$'\t'}
  zpty -w -n ollama-test $'\025'"$line""$tabs"$'\030\002'
  read_until '<<<END>>>' || return 1
  output=$REPLY
  buffer=${${output##*'<<<BUFFER='}%%'>>>'*}
  if [[ $output == *'_describe:'* || $output == *'(eval):'* ||
        $output == *'command not found:'* ]]; then
    print -u2 -r -- "Completion error: ${(qqq)output}"
    return 1
  fi
}

expect_buffer() {
  local description=$1 line=$2 expected=$3 output buffer
  if complete_line "$line" && [[ $buffer == "$expected" ]]; then
    print -r -- "ok - $description"
    (( passed++ ))
  else
    print -u2 -r -- "not ok - $description"
    print -u2 -r -- "  expected ${(qqq)expected}; received ${(qqq)buffer}"
    print -u2 -r -- "  terminal ${(qqq)output}"
    (( failed++ ))
  fi
}

expect_listing() {
  local description=$1 line=$2 output buffer expected
  shift 2
  complete_line "$line" $'\t\t' || { (( failed++ )); return }
  # Metadata assertions ignore padding; alignment is verified separately.
  output=${output//[ ]##--/ --}
  for expected in "$@"; do
    if [[ $output != *$expected* ]]; then
      print -u2 -r -- "not ok - $description (missing $expected)"
      print -u2 -r -- "  terminal ${(qqq)output}"
      (( failed++ ))
      return
    fi
  done
  print -r -- "ok - $description"
  (( passed++ ))
}

# A described completion must occupy its own terminal row. Check rendered ZLE
# output, including aligned description boundaries, without pinning metadata.
expect_described_rows() {
  local description=$1 line=$2 output buffer terminal row reference prefix group
  local -a references=("${(@)argv[3,-1]}")
  local -A seen columns
  integer count rows_ok=1 aligned=1 first_column=0 column
  # Consume the preceding menu's asynchronous redisplay before measuring rows.
  configure_child ':' || { (( failed++ )); return }
  complete_line "$line" $'\t\t' || { (( failed++ )); return }
  terminal=${output//$'\e'\[[0-9\;\?]#[A-Za-z]/}
  for row in "${(@f)terminal}"; do
    count=0
    for reference in "$references[@]"; do
      if [[ $row == *${reference}[[:space:]]* ]]; then
        (( count++ ))
        seen[$reference]=1
        # Mixed run menus contain differently shaped installed/public tables.
        group=bare
        [[ $reference == *:* ]] && group=tagged
      fi
    done
    (( count > 1 )) && rows_ok=0
    if (( count )) && [[ $row == *' -- '* ]]; then
      prefix=${row%% -- *}
      column=${#prefix}
      (( columns[$group] && column != columns[$group] )) && aligned=0
      columns[$group]=$column
      first_column=$column
    fi
  done
  if (( rows_ok && aligned && first_column &&
        ${#seen} == ${#references} )); then
    print -r -- "ok - $description"
    (( passed++ ))
  else
    print -u2 -r -- "not ok - $description"
    print -u2 -r -- "  terminal ${(qqq)terminal}"
    (( failed++ ))
  fi
}

expect_model_fields() {
  local description=$1 line=$2 reference=$3 output buffer terminal row expected
  shift 3
  configure_child ':' || { (( failed++ )); return }
  complete_line "$line" $'\t\t' || { (( failed++ )); return }
  terminal=${output//$'\e'\[[0-9\;\?]#[A-Za-z]/}
  for row in "${(@f)terminal}"; do
    [[ $row == ${reference}[[:space:]]* ]] || continue
    row=${row//[ ]##/ }
    for expected in "$@"; do
      [[ $row == *$expected* ]] || break
    done
    if [[ $row == *$expected* ]]; then
      print -r -- "ok - $description"
      (( passed++ ))
      return
    fi
  done
  print -u2 -r -- "not ok - $description"
  print -u2 -r -- "  terminal ${(qqq)terminal}"
  (( failed++ ))
}

expect_metadata_alignment() {
  local description=$1 line=$2 prefix=$3 output buffer terminal row value
  local -A columns
  integer aligned=1 rows=0 column
  shift 3
  configure_child ':' || { (( failed++ )); return }
  complete_line "$line" $'\t\t' || { (( failed++ )); return }
  terminal=${output//$'\e'\[[0-9\;\?]#[A-Za-z]/}
  for row in "${(@f)terminal}"; do
    [[ $row == ${prefix}*' -- '* ]] || continue
    (( rows++ ))
    for value in "$@"; do
      if [[ $row != *$value* ]]; then
        aligned=0
        continue
      fi
      column=${#${row%%${value}*}}
      (( columns[$value] && column != columns[$value] )) && aligned=0
      columns[$value]=$column
    done
  done
  if (( aligned && rows >= 2 )); then
    print -r -- "ok - $description"
    (( passed++ ))
  else
    print -u2 -r -- "not ok - $description"
    print -u2 -r -- "  terminal ${(qqq)terminal}"
    (( failed++ ))
  fi
}

configure_child() {
  zpty -w -n ollama-test $'\025'"$1; print -r -- '<<<CONFIGURED>>>'"$'\n'
  read_until $'<<<CONFIGURED>>>\r\n'
}

# Check traversal order through the actual completion menu, independent of its
# terminal column layout or description formatting.
expect_menu_order() {
  local description=$1 line=$2 expected output buffer keys=''
  shift 2
  for expected in "$@"; do
    keys+=$'\030\016'
    complete_line "$line" "$keys" || { (( failed++ )); return }
    local actual=${buffer% }
    [[ $line == 'ollama pull ' ]] && actual=${actual%:}
    if [[ $actual != "$line$expected" ]]; then
      print -u2 -r -- "not ok - $description"
      print -u2 -r -- \
        "  expected ${(qqq)line}${(qqq)expected}; received ${(qqq)buffer}"
      print -u2 -r -- "  terminal ${(qqq)REPLY}"
      (( failed++ ))
      return
    fi
  done
  print -r -- "ok - $description"
  (( passed++ ))
}

if [[ ! -s "$scratch/calls" && ! -s "$scratch/requests" ]]; then
  print 'ok - plugin loading makes no CLI or network requests'
  (( passed++ ))
else
  print -u2 'not ok - plugin loading made CLI or network requests'
  (( failed++ ))
fi

expect_listing 'blank pull offers public models absent from local inventory' \
  'ollama pull ' 'embeddinggemma' 'qwen3.5'
if [[ $(< "$scratch/requests") != *'/api/tags'* &&
      $(< "$scratch/requests") != *'/api/ps'* && ! -s "$scratch/calls" ]]; then
  print 'ok - blank pull never queries installed models'
  (( passed++ ))
else
  print -u2 'not ok - blank pull queried installed models'
  (( failed++ ))
fi

# An older sourced plugin can retain a function after fpath changes.
# Verify the documented session reload replaces that function before testing.
configure_child '_ollama() { compadd legacy-local-model; }; compdef _ollama ollama'
expect_buffer 'existing completion function reproduces stale local behavior' \
  'ollama pull legacy-' 'ollama pull legacy-local-model '
configure_child 'fpath=("$OLLAMA_TEST_PLUGIN" $fpath); unfunction _ollama 2>/dev/null; autoload -Uz _ollama; compdef _ollama ollama'
expect_buffer 'session reload replaces existing completion function' \
  'ollama pull embed' 'ollama pull embeddinggemma:'

expect_buffer 'complete command' 'ollama ru' 'ollama run '
expect_buffer 'global version flag' 'ollama --vers' 'ollama --version '
expect_buffer 'serve does not inherit run flags' 'ollama serve --ve' \
  'ollama serve --ve'
expect_buffer 'help command target' 'ollama help ru' 'ollama help run '
expect_buffer 'installed model with colon' 'ollama show qwen3.5:4' \
  'ollama show qwen3.5:4b '
expect_buffer 'show version shorthand means verbose' \
  'ollama show -v qwen3.5:4' 'ollama show -v qwen3.5:4b '
expect_buffer 'model after option value' \
  'ollama run --keepalive 2m gemma3:1' 'ollama run --keepalive 2m gemma3:1b '
expect_buffer 'model after option terminator' 'ollama run -- gemma3:1' \
  'ollama run -- gemma3:1b '
expect_buffer 'bare optional think leaves model positional' \
  'ollama run --think gemma3:1' 'ollama run --think gemma3:1b '
expect_buffer 'think value after equals' 'ollama run --think=hi' \
  'ollama run --think=high '
expect_listing 'options after model' 'ollama run qwen3.5:4b --' '--think' \
  '--keepalive' '--format'
expect_buffer 'copy destination accepts new model name' \
  'ollama cp qwen3.5:4b new-destination' 'ollama cp qwen3.5:4b new-destination'
expect_buffer 'create short file flag before model' 'ollama create -f Mod' \
  'ollama create -f Modelfile '
expect_buffer 'create file flag after model' \
  'ollama create new-model --file Mod' \
  'ollama create new-model --file Modelfile '
expect_listing 'create quantization values' 'ollama create new-model -q in' \
  'int4' 'int8'
expect_listing 'create draft quantization values' \
  'ollama create new-model --draft-quantize mx' 'mxfp4' 'mxfp8'
expect_buffer 'remove accepts multiple installed models' \
  'ollama rm qwen3.5:4b gem' 'ollama rm qwen3.5:4b gemma3:1b '
expect_buffer 'stop completes running models' 'ollama stop qwen3.5:4' \
  'ollama stop qwen3.5:4b '
expect_buffer 'stop does not offer unloaded model' 'ollama stop gem' \
  'ollama stop gem'
expect_buffer 'remote family' 'ollama pull qw' 'ollama pull qwen3.5:'
complete_line 'ollama pull qw' $'\t\t\t'
if [[ $buffer == 'ollama pull qwen3.5:' && $output == *'2.7GB'* ]]; then
  print 'ok - family completion continues directly into tag selection'
  (( passed++ ))
else
  print -u2 'not ok - family completion continues into tag selection'
  (( failed++ ))
fi
configure_child "zmodload zsh/complist; zstyle ':completion:*' menu yes select; bindkey '^I' complete-word; bindkey -M menuselect '^M' .accept-line"
complete_line 'ollama pull ' $'\t\t\r'
if [[ $buffer == 'ollama pull '*: && $buffer != *' '*': '* ]]; then
  print 'ok - Enter accepts a family with a colon in the completion menu'
  (( passed++ ))
else
  print -u2 'not ok - Enter accepts a family with a colon'
  print -u2 -r -- "  received ${(qqq)buffer}"
  print -u2 -r -- "  terminal ${(qqq)output}"
  (( failed++ ))
fi
configure_child "zstyle ':completion:*' menu no; bindkey '^I' complete-word"
expect_buffer 'remote tag' 'ollama pull qwen3.5:4b-' \
  'ollama pull qwen3.5:4b-mlx '
expect_listing 'remote tag choices' 'ollama pull qwen3.5:' '4b' '4b-mlx' '9b'
expect_listing 'default tag label on concrete variant' \
  'ollama pull qwen3.5:' '*latest (default)'
expect_buffer 'latest is not a duplicate tag' 'ollama pull qwen3.5:lat' \
  'ollama pull qwen3.5:lat'
expect_listing 'bare exact model offers concrete tags' 'ollama pull qwen3.5' \
  'qwen3.5:4b' 'qwen3.5:4b-mlx' 'qwen3.5:9b'
expect_buffer 'remote model with namespace' 'ollama pull team/custom:sm' \
  'ollama pull team/custom:small-v1 '
expect_buffer 'explicit library namespace' 'ollama pull library/qwen3.5:4b-' \
  'ollama pull library/qwen3.5:4b-mlx '

# Every local-model entry carries size information, regardless of sort mode or
# which subcommand requested it. Menus must remain one row per candidate.
expect_described_rows 'run mixed local and public model menu uses rows' \
  'ollama run ' gemma3:1b qwen3.5:4b embeddinggemma gemma3 qwen3.5
for model_command in show push cp rm; do
  expect_described_rows "$model_command model sizes use aligned rows" \
    "ollama $model_command " gemma3:1b qwen3.5:4b
done
expect_described_rows 'stop running model sizes use aligned rows' \
  'ollama stop ' qwen3.5:4b qwen3.5:9b
expect_described_rows 'launch model sizes use aligned rows' \
  'ollama launch codex --model ' gemma3:1b qwen3.5:4b
expect_described_rows 'command descriptions use aligned rows' \
  'ollama ' serve create run stop
expect_described_rows 'help command descriptions use aligned rows' \
  'ollama help ' serve create run stop
expect_described_rows 'integration descriptions use aligned rows' \
  'ollama launch ' claude codex droid opencode
expect_described_rows 'root option descriptions use aligned rows' \
  'ollama --' --help --version
expect_described_rows 'run option descriptions use aligned rows' \
  'ollama run --' --format --keepalive --think
configure_child ':'
complete_line 'ollama run ' $'\t\t'
terminal=${output//$'\e'\[[0-9\;\?]#[A-Za-z]/}
# Inspect the first public header, so later menu redisplays cannot hide a header
# incorrectly printed before the installed rows it should follow.
if [[ $terminal == *'Family capabilities'* &&
      ${terminal%%'Family capabilities'*} == *gemma3:1b* &&
      ${terminal#*'Family capabilities'} == *embeddinggemma* ]]; then
  print 'ok - mixed model headers precede their own candidate rows'
  (( passed++ ))
else
  print -u2 'not ok - mixed model headers precede their own candidate rows'
  print -u2 -r -- "  terminal ${(qqq)terminal}"
  (( failed++ ))
fi
expect_listing 'installed model table exposes available metadata columns' \
  'ollama show ' Model Size Modified Context Capabilities Cloud
expect_model_fields 'installed model row shows modification and unknown context' \
  'ollama show ' qwen3.5:4b '2.7GB' '2026-10-01 - ' \
  'completion' 'tools' 'thinking'
expect_listing 'running table identifies loaded rather than supported context' \
  'ollama stop ' Model Size 'Loaded context'
expect_model_fields 'running model row shows actual loaded context' \
  'ollama stop ' qwen3.5:4b '2.7GB' '4096'
expect_listing 'public family table exposes library metadata columns' \
  'ollama pull ' Model Updated Context 'Family capabilities' Cloud
expect_model_fields 'public family row shows date context capabilities and cloud' \
  'ollama pull ' qwen3.5 '2026-10-01' '256K' \
  'tools,vision,thinking' 'yes'

configure_child "zstyle ':completion:*' menu yes"
expect_menu_order 'default natural tag order' 'ollama pull sort-model:' 0.8b \
  2b 9b 27b 122b missing
configure_child "zstyle ':completion:*:ollama*:*' model-sort alphabetical"
expect_menu_order 'alphabetical tag order' 'ollama pull sort-model:' 0.8b \
  122b 27b 2b 9b missing
configure_child "zstyle ':completion:*:ollama*:*' model-sort reverse"
expect_menu_order 'reverse natural tag order' 'ollama pull sort-model:' \
  missing 122b 27b 9b 2b 0.8b
configure_child "zstyle ':completion:*:ollama*:*' model-sort newest"
expect_menu_order 'newest families follow newest library additions' \
  'ollama pull ' gemma3 embeddinggemma qwen3.5
if [[ $(< "$scratch/requests") == *'/api/v1/models?sort=newest'* ]]; then
  print 'ok - newest family ordering requests the shared newest feed'
  (( passed++ ))
else
  print -u2 'not ok - newest ordering did not request the newest feed'
  (( failed++ ))
fi
configure_child "zstyle ':completion:*:ollama*:*' model-sort latest-first"
expect_menu_order 'latest tag first with natural order for other tags' \
  'ollama pull sort-model:' 9b 0.8b 2b 27b 122b missing
configure_child "zstyle ':completion:*:ollama*:*' model-sort newest; zstyle ':completion:*:ollama-pull:*:model-tags' model-sort natural"
expect_menu_order 'newest families can coexist with natural tag ordering' \
  'ollama pull sort-model:' 0.8b 2b 9b 27b 122b missing
configure_child "zstyle -d ':completion:*:ollama-pull:*:model-tags' model-sort"
expect_menu_order 'newest tag ordering falls back to natural' \
  'ollama pull sort-model:' 0.8b 2b 9b 27b 122b missing
configure_child "zstyle ':completion:*:ollama*:*' model-sort popular"
expect_menu_order 'popular families follow library popularity' \
  'ollama pull ' qwen3.5 embeddinggemma gemma3
if [[ $(< "$scratch/requests") == *'/api/v1/models?sort=popular'* ]]; then
  print 'ok - popular family ordering requests the shared popularity feed'
  (( passed++ ))
else
  print -u2 'not ok - popular ordering did not request the popularity feed'
  (( failed++ ))
fi
expect_menu_order 'popular tag ordering falls back to natural' \
  'ollama pull sort-model:' 0.8b 2b 9b 27b 122b missing
configure_child "zstyle ':completion:*:ollama*:*' model-sort source"
expect_menu_order 'source tag order' 'ollama pull sort-model:' 27b 2b 122b \
  9b 0.8b missing
expect_menu_order 'source family order' 'ollama pull ' qwen3.5 gemma3 \
  embeddinggemma
expect_menu_order 'source local model order' 'ollama show ' qwen3.5:4b gemma3:1b
configure_child "zstyle ':completion:*:ollama*:*' model-sort natural"
expect_menu_order 'natural family order' 'ollama pull ' embeddinggemma \
  gemma3 qwen3.5
expect_menu_order 'natural local model order' 'ollama show ' gemma3:1b \
  qwen3.5:4b
configure_child "zstyle ':completion:*:ollama-pull:*:model-tags' model-sort source"
expect_menu_order 'tag-specific style overrides general model order' \
  'ollama pull sort-model:' 27b 2b 122b 9b 0.8b missing
configure_child "zstyle -d ':completion:*:ollama-pull:*:model-tags' model-sort; zstyle ':completion:*:ollama*:*' model-sort invalid"
expect_menu_order 'invalid sorting falls back to natural order' \
  'ollama pull sort-model:' 0.8b 2b 9b 27b 122b missing
configure_child "zstyle ':completion:*:ollama*:*' model-sort size"
expect_menu_order \
  'size order normalizes units and ranges with unknown sizes last' \
  'ollama pull sort-model:' 2b 0.8b 9b 27b 122b missing
expect_menu_order \
  'family size order uses latest variant rather than smallest variant' \
  'ollama pull ' embeddinggemma qwen3.5 gemma3
expect_menu_order 'installed model size order' 'ollama show ' gemma3:1b \
  qwen3.5:4b
configure_child "zstyle ':completion:*:ollama*:*' model-sort reverse-size"
expect_menu_order \
  'reverse size order keeps natural ties and unknown sizes last' \
  'ollama pull sort-model:' 122b 27b 0.8b 9b 2b missing
expect_menu_order 'reverse family size order uses latest variant' \
  'ollama pull ' gemma3 qwen3.5 embeddinggemma
expect_menu_order 'reverse installed model size order' 'ollama show ' \
  qwen3.5:4b gemma3:1b
configure_child "zstyle -d ':completion:*:ollama*:*' model-sort; zstyle ':completion:*' menu no"
expect_model_fields 'download size and latest marker stay attached to tag' \
  'ollama pull qwen3.5:' qwen3.5:4b '2.7GB' '*latest (default)'
expect_model_fields 'alternate tag preserves its download size' \
  'ollama pull qwen3.5:' qwen3.5:4b-mlx '2.8GB'
expect_model_fields 'tag preserves download size range' \
  'ollama pull qwen3.5:' qwen3.5:9b '6.6GB - 7.6GB'
expect_model_fields 'missing tag size is explicit in the size column' \
  'ollama pull sort-model:' sort-model:missing ' -- - '
expect_model_fields 'tag metadata shows relative update context and capabilities' \
  'ollama pull qwen3.5:' qwen3.5:4b '1 week ago' '256K' \
  'tools,vision,thinking' 'no'
expect_metadata_alignment 'tag metadata columns align across different sizes' \
  'ollama pull qwen3.5:' qwen3.5: '1 week ago' '256K' \
  'tools,vision,thinking' 'no'

# The one-per-line layout is a user-visible requirement, independent of columns.
complete_line 'ollama pull qwen3.5:' $'\t\t'
terminal=${output//$'\e'\[[0-9\;\?]#[A-Za-z]/}
integer rows_ok=1 count
for row in "${(@f)terminal}"; do
  count=0
  for reference in qwen3.5:4b-mlx qwen3.5:9b qwen3.5:4b; do
    [[ $row == *${reference}[[:space:]]* ]] && (( count++ ))
  done
  (( count > 1 )) && rows_ok=0
done
if (( rows_ok )) &&
   [[ $terminal == *'qwen3.5:4b-mlx'* && $terminal == *'qwen3.5:9b'* ]]; then
  print 'ok - tag list displays one variant per line'
  (( passed++ ))
else
  print -u2 'not ok - tag list displays one variant per line'
  (( failed++ ))
fi

# Size alignment is a required visual contract, not an incidental snapshot.
integer size_column=0 aligned_rows=0 aligned=1 column
for row in "${(@f)terminal}"; do
  [[ $row == *qwen3.5:*' -- '* ]] || continue
  column=${#${row%% -- *}}
  (( size_column && column != size_column )) && aligned=0
  size_column=$column
  (( aligned_rows++ ))
done
if (( aligned && aligned_rows >= 3 )); then
  print 'ok - tag download sizes align in one column'
  (( passed++ ))
else
  print -u2 'not ok - tag download sizes align in one column'
  print -u2 -r -- "  terminal ${(qqq)terminal}"
  (( failed++ ))
fi

configure_child "zstyle ':completion:*:ollama*:*' model-sort size"
before_sizes=$(< "$scratch/requests")
expect_buffer 'size lookup only fetches families matching the prefix' \
  'ollama pull embed' 'ollama pull embeddinggemma:'
after_sizes=$(< "$scratch/requests")
new_sizes=${after_sizes#$before_sizes}
if [[ $new_sizes == *'/api/v1/models?names=embeddinggemma'* &&
      $new_sizes != *'?names=gemma3'* && $new_sizes != *'?names=qwen3.5'* ]]; then
  print 'ok - unmatched families make no size metadata requests'
  (( passed++ ))
else
  print -u2 'not ok - unmatched families make no size metadata requests'
  print -u2 -r -- "  new requests ${(qqq)new_sizes}"
  (( failed++ ))
fi
complete_line 'ollama pull ' $'\t\t'
if [[ $output != *latest* ]]; then
  print 'ok - sized bare model names remain unlabelled as latest'
  (( passed++ ))
else
  print -u2 'not ok - sized bare model names were labelled latest'
  (( failed++ ))
fi
configure_child "zstyle -d ':completion:*:ollama*:*' model-sort; zstyle ':completion:*' menu no"

# Family sizes are sorting metadata, never displayed download information.
for family_order in natural alphabetical reverse latest-first newest popular \
                    source size reverse-size; do
  configure_child \
    "zstyle ':completion:*:ollama*:*' model-sort $family_order"
  complete_line 'ollama pull ' $'\t\t'
  if [[ $output == *embeddinggemma* && $output != *Size* &&
        $output != *[0-9](GB|MB|TB)* &&
        $output != *'size unavailable'* ]]; then
    print -r -- "ok - family names hide size metadata in $family_order order"
    (( passed++ ))
  else
    print -u2 -r -- "not ok - family names hide sizes in $family_order order"
    print -u2 -r -- "  terminal ${(qqq)output}"
    (( failed++ ))
  fi
done
configure_child "zstyle -d ':completion:*:ollama*:*' model-sort"

# Changing shared-service responses must be visible on the next Tab.
command touch "$scratch/updated"
expect_buffer 'completion sees updated service metadata on the next Tab' \
  'ollama pull qwen3.5:9b-' 'ollama pull qwen3.5:9b-mlx '
command touch "$scratch/invalid-response"
expect_buffer 'invalid successful HTTP response retains validated metadata' \
  'ollama pull qwen3.5:9b-' 'ollama pull qwen3.5:9b-mlx '
command rm "$scratch/invalid-response"
configure_child "zstyle ':completion:*' metadata-url https://alternate.test"
expect_buffer 'metadata endpoint override completes public tags' \
  'ollama pull qwen3.5:4b-m' 'ollama pull qwen3.5:4b-mlx '
if [[ $(< "$scratch/requests") ==
      *'https://alternate.test/api/v1/tags?model=qwen3.5'* ]]; then
  print 'ok - metadata endpoint override sends request to configured service'
  (( passed++ ))
else
  print -u2 'not ok - metadata endpoint override was ignored'
  (( failed++ ))
fi
configure_child "zstyle ':completion:*' metadata-url https://metadata.test"
command touch "$scratch/offline"
configure_child "zstyle ':completion:*' metadata-url https://legacy-cache.test; _OLLAMA_CATALOGUE_CACHE['https://legacy-cache.test/api/v1/models|||']=\$'legacy-model\\t\\t\\t0'"
expect_buffer 'four-field shell cache cannot populate enriched model tables' \
  'ollama pull legacy-' 'ollama pull legacy-'
configure_child "zstyle ':completion:*' metadata-url https://metadata.test"
configure_child "zstyle ':completion:*:ollama*:*' model-sort newest; zstyle ':completion:*' menu yes"
expect_menu_order 'offline newest families retain their own cache order' \
  'ollama pull ' gemma3 embeddinggemma qwen3.5
configure_child "zstyle ':completion:*:ollama*:*' model-sort popular"
expect_menu_order 'offline popular families retain their own cache order' \
  'ollama pull ' qwen3.5 embeddinggemma gemma3
configure_child "zstyle -d ':completion:*:ollama*:*' model-sort; zstyle ':completion:*' menu no"
expect_buffer 'offline completion retains successful catalogue' \
  'ollama pull qwen3.5:9b-' 'ollama pull qwen3.5:9b-mlx '
configure_child "zstyle ':completion:*:ollama*:*' model-sort reverse; zstyle ':completion:*' menu yes"
expect_menu_order 'sort changes also apply to cached offline tags' \
  'ollama pull sort-model:' missing 122b 27b 9b 2b 0.8b
configure_child "zstyle ':completion:*:ollama*:*' model-sort reverse-size"
expect_menu_order 'offline family sorting reuses latest sizes' \
  'ollama pull ' gemma3 qwen3.5 embeddinggemma
configure_child "zstyle -d ':completion:*:ollama*:*' model-sort; zstyle ':completion:*' menu no"
expect_buffer 'cold offline failure leaves input intact' \
  'ollama pull --insecure team/cold:sm' 'ollama pull --insecure team/cold:sm'
command rm -- "$scratch/offline"

configure_child "zstyle ':completion:*' remote-models no"
before_disable=$(< "$scratch/requests")
expect_buffer 'remote catalogue can be disabled' 'ollama pull qwen3.5:4b-' \
  'ollama pull qwen3.5:4b-'
if [[ $(< "$scratch/requests") == "$before_disable" ]]; then
  print 'ok - disabling remote completion prevents registry requests'
  (( passed++ ))
else
  print -u2 'not ok - disabled remote completion requested the registry'
  (( failed++ ))
fi
configure_child "zstyle ':completion:*' remote-models yes"
expect_buffer 'launch integration' 'ollama launch dro' 'ollama launch droid '
expect_buffer 'launch existing integration alias' 'ollama launch claude-co' \
  'ollama launch claude-code '
expect_listing 'launch plural integration aliases' 'ollama launch opencode-' \
  'opencode-cli' 'opencode-tool'
expect_buffer 'launch restore excludes model flag' \
  'ollama launch --restore --mod' 'ollama launch --restore --mod'
expect_buffer 'launch passes integration flags through' \
  'ollama launch claude -- --downstream-fla' \
  'ollama launch claude -- --downstream-fla'
configure_child 'PATH="$OLLAMA_TEST_SCRATCH/no-jq"; rehash'
expect_buffer 'local completion without jq leaves input intact' \
  'ollama show qwen3.5:4' 'ollama show qwen3.5:4'
expect_buffer 'remote completion works without jq' 'ollama pull qwen3.5:4b-' \
  'ollama pull qwen3.5:4b-mlx '
configure_child 'PATH=$OLLAMA_TEST_ORIGINAL_PATH; rehash'

# Every subprocess Ollama invocation must be the explicit read-only help probe.
if [[ -f "$scratch/calls" ]] &&
   [[ $(< "$scratch/calls") == *UNEXPECTED* ]]; then
  print -u2 'not ok - completion executed an unexpected Ollama command'
  (( failed++ ))
else
  print 'ok - no Ollama command execution beyond help'
  (( passed++ ))
fi
if [[ -f "$scratch/requests" ]] &&
   [[ $(< "$scratch/requests") == *UNEXPECTED* ]]; then
  print -u2 'not ok - completion requested an unexpected network endpoint'
  (( failed++ ))
else
  print 'ok - only expected network endpoints requested'
  (( passed++ ))
fi
print -r -- "$passed passed; $failed failed"
(( failed == 0 ))
