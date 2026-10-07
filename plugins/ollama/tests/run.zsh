#!/bin/zsh -f
# Run with /bin/zsh -f plugins/ollama/tests/run.zsh.
# The child shell presses Tab using ZLE; it never submits an Ollama command.
emulate -LR zsh
setopt extendedglob
zmodload zsh/zpty || exit 1
zmodload zsh/zselect || exit 1

readonly test_dir=${0:A:h}
readonly plugin_dir=${test_dir:h}
readonly scratch=$(mktemp -d "${TMPDIR:-/tmp}/ollama-completion.XXXXXXXX") || exit 1
integer passed=0 failed=0

cleanup() {
  zpty -d ollama-test 2>/dev/null
  command rm -rf -- "$scratch"
}
trap cleanup EXIT INT TERM
command mkdir -p "$scratch/bin" "$scratch/no-jq" "$scratch/cache" "$scratch/empty"
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
unsetopt automenu menucomplete
setopt autolist listambiguous
_test_dump_buffer() {
  print -r -- "<<<BUFFER=$BUFFER>>>"
  print -r -- '<<<END>>>'
  zle redisplay
}
zle -N _test_dump_buffer
bindkey '^I' complete-word
bindkey '^X^B' _test_dump_buffer
print -r -- '<<<READY>>>'
SETUP

zpty -b ollama-test /bin/zsh -dfi
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
  if [[ $output == *'_describe:'* || $output == *'(eval):'* || $output == *'command not found:'* ]]; then
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

configure_child() {
  zpty -w -n ollama-test $'\025'"$1; print -r -- '<<<CONFIGURED>>>'"$'\n'
  read_until $'<<<CONFIGURED>>>\r\n'
}

if [[ ! -s "$scratch/calls" && ! -s "$scratch/requests" ]]; then
  print 'ok - plugin loading makes no CLI or network requests'
  (( passed++ ))
else
  print -u2 'not ok - plugin loading made CLI or network requests'
  (( failed++ ))
fi

expect_buffer 'complete command' 'ollama ru' 'ollama run '
expect_buffer 'global version flag' 'ollama --vers' 'ollama --version '
expect_buffer 'serve does not inherit run flags' 'ollama serve --ve' 'ollama serve --ve'
expect_buffer 'help command target' 'ollama help ru' 'ollama help run '
expect_buffer 'installed model with colon' 'ollama show qwen3.5:4' 'ollama show qwen3.5:4b '
expect_buffer 'show version shorthand means verbose' 'ollama show -v qwen3.5:4' 'ollama show -v qwen3.5:4b '
expect_buffer 'model after option value' 'ollama run --keepalive 2m gemma3:1' 'ollama run --keepalive 2m gemma3:1b '
expect_buffer 'model after option terminator' 'ollama run -- gemma3:1' 'ollama run -- gemma3:1b '
expect_buffer 'bare optional think leaves model positional' 'ollama run --think gemma3:1' 'ollama run --think gemma3:1b '
expect_buffer 'think value after equals' 'ollama run --think=hi' 'ollama run --think=high '
expect_listing 'options after model' 'ollama run qwen3.5:4b --' '--think' '--keepalive' '--format'
expect_buffer 'copy destination accepts new model name' 'ollama cp qwen3.5:4b new-destination' 'ollama cp qwen3.5:4b new-destination'
expect_buffer 'create short file flag before model' 'ollama create -f Mod' 'ollama create -f Modelfile '
expect_buffer 'create file flag after model' 'ollama create new-model --file Mod' 'ollama create new-model --file Modelfile '
expect_listing 'create quantization values' 'ollama create new-model -q in' 'int4' 'int8'
expect_listing 'create draft quantization values' 'ollama create new-model --draft-quantize mx' 'mxfp4' 'mxfp8'
expect_buffer 'remove accepts multiple installed models' 'ollama rm qwen3.5:4b gem' 'ollama rm qwen3.5:4b gemma3:1b '
expect_buffer 'stop completes running models' 'ollama stop qwen3.5:4' 'ollama stop qwen3.5:4b '
expect_buffer 'stop does not offer unloaded model' 'ollama stop gem' 'ollama stop gem'
expect_buffer 'remote family' 'ollama pull qw' 'ollama pull qwen3.5 '
expect_buffer 'remote tag' 'ollama pull qwen3.5:4b-' 'ollama pull qwen3.5:4b-mlx '
expect_listing 'remote tag choices' 'ollama pull qwen3.5:' '4b' '4b-mlx' '9b'
expect_listing 'default tag label on concrete variant' 'ollama pull qwen3.5:' '*latest (default)'
expect_buffer 'latest is not a duplicate tag' 'ollama pull qwen3.5:lat' 'ollama pull qwen3.5:lat'
expect_listing 'bare exact model offers concrete tags' 'ollama pull qwen3.5' 'qwen3.5:4b' 'qwen3.5:4b-mlx' 'qwen3.5:9b'
expect_buffer 'remote model with namespace' 'ollama pull team/custom:sm' 'ollama pull team/custom:small-v1 '
expect_buffer 'explicit library namespace' 'ollama pull library/qwen3.5:4b-' 'ollama pull library/qwen3.5:4b-mlx '

# Changing server responses must be visible on the next Tab, with no TTL wait.
command touch "$scratch/updated"
expect_buffer 'remote catalogue refreshes on each Tab' 'ollama pull qwen3.5:9b-' 'ollama pull qwen3.5:9b-mlx '
command touch "$scratch/offline"
expect_buffer 'offline completion retains successful catalogue' 'ollama pull qwen3.5:9b-' 'ollama pull qwen3.5:9b-mlx '
expect_buffer 'cold offline failure leaves input intact' 'ollama pull --insecure team/cold:sm' 'ollama pull --insecure team/cold:sm'
command rm -- "$scratch/offline"

configure_child "zstyle ':completion:*' remote-models no"
before_disable=$(< "$scratch/requests")
expect_buffer 'remote catalogue can be disabled' 'ollama pull qwen3.5:4b-' 'ollama pull qwen3.5:4b-'
if [[ $(< "$scratch/requests") == "$before_disable" ]]; then
  print 'ok - disabling remote completion prevents registry requests'
  (( passed++ ))
else
  print -u2 'not ok - disabled remote completion requested the registry'
  (( failed++ ))
fi
configure_child "zstyle ':completion:*' remote-models yes"
expect_buffer 'launch integration' 'ollama launch dro' 'ollama launch droid '
expect_buffer 'launch existing integration alias' 'ollama launch claude-co' 'ollama launch claude-code '
expect_listing 'launch plural integration aliases' 'ollama launch opencode-' 'opencode-cli' 'opencode-tool'
expect_buffer 'launch restore excludes model flag' 'ollama launch --restore --mod' 'ollama launch --restore --mod'
expect_buffer 'launch passes integration flags through' 'ollama launch claude -- --downstream-fla' 'ollama launch claude -- --downstream-fla'
configure_child 'PATH="$OLLAMA_TEST_SCRATCH/no-jq"; rehash'
expect_buffer 'local completion without jq leaves input intact' 'ollama show qwen3.5:4' 'ollama show qwen3.5:4'
expect_buffer 'remote completion works without jq' 'ollama pull qwen3.5:4b-' 'ollama pull qwen3.5:4b-mlx '
configure_child 'PATH=$OLLAMA_TEST_ORIGINAL_PATH; rehash'

# Every subprocess Ollama invocation must be the explicit read-only help probe.
if [[ -f "$scratch/calls" ]] && [[ $(< "$scratch/calls") == *UNEXPECTED* ]]; then
  print -u2 'not ok - completion executed an unexpected Ollama command'
  (( failed++ ))
else
  print 'ok - no Ollama command execution beyond help'
  (( passed++ ))
fi
if [[ -f "$scratch/requests" ]] && [[ $(< "$scratch/requests") == *UNEXPECTED* ]]; then
  print -u2 'not ok - completion requested an unexpected network endpoint'
  (( failed++ ))
else
  print 'ok - only expected network endpoints requested'
  (( passed++ ))
fi
print -r -- "$passed passed; $failed failed"
(( failed == 0 ))
