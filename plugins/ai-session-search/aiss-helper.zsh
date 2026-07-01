#!/usr/bin/env zsh
# aiss-helper.zsh — scanning + preview rendering for ai-session-search.
# Invoked as a standalone script (not sourced):
#   zsh aiss-helper.zsh scan
#   zsh aiss-helper.zsh preview <provider> <file>
#
# Kept separate from the plugin so the fzf child shell can call back into it
# without needing the plugin's zsh functions in scope.

emulate -L zsh
setopt null_glob extended_glob pipefail 2>/dev/null
zmodload zsh/datetime 2>/dev/null
zmodload -F zsh/stat b:zstat 2>/dev/null

CLAUDE_DIR=${AISS_CLAUDE_DIR:-$HOME/.claude/projects}
CODEX_DIR=${AISS_CODEX_DIR:-$HOME/.codex/sessions}
GEMINI_DIR=${AISS_GEMINI_DIR:-$HOME/.gemini/tmp}
COPILOT_DIR=${AISS_COPILOT_DIR:-$HOME/.copilot/session-state}

PREVIEW_MAX=${AISS_PREVIEW_LEN:-100}   # chars of preview shown in the list

# ---- jq filters (single-pass, slurped) ------------------------------------
#
# NOTE: assign via $(cat <<'JQ' ... JQ) — NOT `read -r -d '' VAR <<'JQ'`.
# The `read` builtin consuming a heredoc HANGS when this script runs as an fzf
# `--preview` command (fzf runs previews in a background process group, where
# the builtin blocks). Forking `cat` sidesteps it. See README "Gotchas".

# Claude: emit  cwd \t first-real-user-prompt
JQ_CLAUDE=$(cat <<'JQ'
. as $a
| (first($a[] | .cwd? // empty) // "") as $cwd
| (first(
    $a[]
    | select(.type=="user")
    | (.message.content) as $c
    | (if   ($c|type)=="string" then $c
       elif ($c|type)=="array"  then (first($c[] | select(.type=="text") | .text) // empty)
       else empty end)
    | select(type=="string" and . != "")
    | select(test("^<")|not)          # skip <command-name>, <local-command...> etc.
    | select(test("^Caveat:")|not)
  ) // "") as $p
| [ $cwd, ($p | gsub("[\\n\\t\\r]+"; " ")) ] | @tsv
JQ
)

# Codex: emit  id \t cwd \t first-real-user-prompt
JQ_CODEX=$(cat <<'JQ'
. as $a
| (first($a[] | select(.type=="session_meta") | .payload)) as $m
| (first(
    $a[]
    | select((.payload.type? // "")=="message" and (.payload.role? // "")=="user")
    | .payload.content[]?
    | (.text // empty)
    | select(type=="string" and . != "")
    | select(test("^(<(environment_context|user_instructions|permissions|INSTRUCTIONS)|# AGENTS\\.md)")|not)
  ) // "") as $p
| [ ($m.id // ""), ($m.cwd // ""), ($p | gsub("[\\n\\t\\r]+"; " ")) ] | @tsv
JQ
)

# Copilot CLI: emit  cwd \t first-real-user-prompt  (events.jsonl event stream)
JQ_COPILOT=$(cat <<'JQ'
. as $a
| (first($a[] | select(.type=="session.start") | .data.context.cwd) // "") as $cwd
| (first(
    $a[] | select(.type=="user.message") | .data.content
    | select(type=="string" and . != "")
    | select(test("^<")|not)
  ) // "") as $p
| [ $cwd, ($p | gsub("[\\n\\t\\r]+"; " ")) ] | @tsv
JQ
)

# ---- preview renderers ----------------------------------------------------

JQ_CLAUDE_PREVIEW=$(cat <<'JQ'
.[]
| select(.type=="user" or .type=="assistant")
| (.type) as $role
| (.message.content) as $c
| (if   ($c|type)=="string" then $c
   elif ($c|type)=="array" then
     ([ $c[]
        | (.text
           // (if .type=="tool_use"    then "🔧 " + (.name // "tool")
               elif .type=="tool_result" then "↩  [tool result]"
               else empty end)) ] | join("\n"))
   else "" end) as $t
| select($t != "")
| (if $role=="user" then "\u001b[1;36m▶ USER\u001b[0m" else "\u001b[1;32m◀ ASSISTANT\u001b[0m" end)
  + "\n" + $t + "\n"
JQ
)

JQ_CODEX_PREVIEW=$(cat <<'JQ'
.[]
| select((.payload.type? // "")=="message")
| (.payload.role) as $role
| select($role=="user" or $role=="assistant")
| ([ .payload.content[]? | (.text // empty) ] | join("\n")) as $t
| select($t != "")
| select(($role=="user" and ($t | test("^(<(environment_context|user_instructions|permissions|INSTRUCTIONS)|# AGENTS\\.md)"))) | not)
| (if $role=="user" then "\u001b[1;36m▶ USER\u001b[0m" else "\u001b[1;32m◀ ASSISTANT\u001b[0m" end)
  + "\n" + $t + "\n"
JQ
)

JQ_COPILOT_PREVIEW=$(cat <<'JQ'
.[]
| select(.type=="user.message" or .type=="assistant.message")
| (.type) as $ty
| (if $ty=="user.message" then (.data.content // "")
   else ((.data.content // "")
         + ([ (.data.toolRequests // [])[] | "\n🔧 " + (.name // "tool") ] | join(""))) end) as $t
| select($t != "")
| (if $ty=="user.message" then "\u001b[1;36m▶ USER\u001b[0m" else "\u001b[1;32m◀ ASSISTANT\u001b[0m" end)
  + "\n" + $t + "\n"
JQ
)

# Session metadata (for the preview header), emitted as one line whose fields
# are joined with U+001F (unit separator) so empty fields don't collapse.
JQ_CLAUDE_META=$(cat <<'JQ'
. as $a
| [ $a[] | .timestamp // empty ] as $ts
| [ (($ts[0] // ""), ($ts[-1] // "")) | (sub("\\.[0-9]+Z$";"Z") | fromdateiso8601?) // 0 ] as $ep
| [ (first($a[] | select(.type=="assistant") | .message.model // empty | select(test("^<")|not)) // "?"),
    (first($a[] | .version // empty) // ""),
    ((first($a[] | .gitBranch // empty) // "") | if . == "HEAD" then "" else . end),
    (first($a[] | .cwd // empty) // ""),
    ($ep[0]|tostring), ($ep[1]|tostring),
    ([$a[] | select(.type=="user")]      | length | tostring),
    ([$a[] | select(.type=="assistant")] | length | tostring)
  ] | join("\u001f")
JQ
)

JQ_CODEX_META=$(cat <<'JQ'
. as $a
| [ $a[] | .timestamp // empty ] as $ts
| [ (($ts[0] // ""), ($ts[-1] // "")) | (sub("\\.[0-9]+Z$";"Z") | fromdateiso8601?) // 0 ] as $ep
| (first($a[] | select(.type=="session_meta") | .payload) // {}) as $m
| [ (first($a[] | .payload.model // empty) // "?"),
    ($m.model_provider // ""),
    ($m.cli_version // ""),
    ($m.cwd // ""),
    ($ep[0]|tostring), ($ep[1]|tostring),
    ([$a[] | select((.payload.role? // "")=="user")]      | length | tostring),
    ([$a[] | select((.payload.role? // "")=="assistant")] | length | tostring)
  ] | join("\u001f")
JQ
)

JQ_COPILOT_META=$(cat <<'JQ'
. as $a
| [ $a[] | .timestamp // empty ] as $ts
| [ (($ts[0] // ""), ($ts[-1] // "")) | (sub("\\.[0-9]+Z$";"Z") | fromdateiso8601?) // 0 ] as $ep
| (first($a[] | select(.type=="session.start") | .data)) as $s
| [ ((last($a[] | select(.type=="assistant.message") | .data.model)) // (last($a[] | select(.type=="session.model_change") | .data.newModel)) // "?"),
    ($s.copilotVersion // ""),
    "",
    ($s.context.cwd // ""),
    ($ep[0]|tostring), ($ep[1]|tostring),
    ([$a[] | select(.type=="user.message")]      | length | tostring),
    ([$a[] | select(.type=="assistant.message")] | length | tostring)
  ] | join("\u001f")
JQ
)

# ---------------------------------------------------------------------------

# Render a boxed metadata header for the preview pane.
# _aiss_header <provider> <cwd> <branch> <model> <ver-line> <t0epoch> <t1epoch> <nUser> <nAsst>
_aiss_header() {
  local provider=$1 cwd=$2 branch=$3 model=$4 verline=$5 t0=$6 t1=$7 nu=$8 na=$9
  local cwd_disp=${cwd/#$HOME/\~} d0 d1 dur day0 day1
  if [[ $t0 == <-> ]] && (( t0 > 0 )); then
    strftime -s d0 '%Y-%m-%d %H:%M' $t0; strftime -s day0 '%Y-%m-%d' $t0
  else d0='?'; fi
  if [[ $t1 == <-> ]] && (( t1 > 0 )); then
    strftime -s day1 '%Y-%m-%d' $t1
    # show the end date too when the session spans more than one day
    if [[ $day1 == $day0 ]]; then strftime -s d1 '%H:%M' $t1
    else strftime -s d1 '%m-%d %H:%M' $t1; fi
  else d1='?'; fi
  if [[ $t0 == <-> && $t1 == <-> ]] && (( t0 > 0 && t1 >= t0 )); then
    local s=$(( t1 - t0 ))
    if   (( s >= 86400 )); then dur=$(printf '%dd%dh' $((s/86400)) $(((s%86400)/3600)))
    elif (( s >= 3600  )); then dur=$(printf '%dh%dm' $((s/3600)) $(((s%3600)/60)))
    elif (( s >= 60    )); then dur=$(printf '%dm' $((s/60)))
    else                        dur=$(printf '%ds' $s); fi
  else dur='?'; fi
  local C=$'\e[36m' B=$'\e[1m' D=$'\e[2m' R=$'\e[0m'
  print -r -- "${C}╭─ ${B}${provider}${R}${C} · ${model}${R}"
  print -r -- "${C}│${R} 📁 ${cwd_disp}${branch:+  ${D}⎇ ${branch}${R}}"
  print -r -- "${C}│${R} 🕐 ${d0} → ${d1}  ${D}(${dur})${R}"
  print -r -- "${C}│${R} 💬 ${nu} user · ${na} assistant${verline:+   ${D}${verline}${R}}"
  print -r -- "${C}╰──────────────────────────────────────────${R}"
  print -r -- ""
}

_emit() {
  # _emit <epoch> <provider> <id> <cwd> <preview> <file>
  local epoch=$1 provider=$2 id=$3 cwd=$4 preview=$5 file=$6
  [[ -z $preview ]] && preview="(no prompt)"
  local cwd_disp=${cwd/#$HOME/\~}
  # epoch is kept only as a sort key (stripped before fzf sees it); the visible
  # row is: provider  cwd  preview
  # field layout:  epoch \t display \t provider \t id \t cwd \t file
  printf '%s\t%-6s  %-34.34s  %.*s\t%s\t%s\t%s\t%s\n' \
    "$epoch" "$provider" "$cwd_disp" "$PREVIEW_MAX" "$preview" \
    "$provider" "$id" "$cwd" "$file"
}

scan() {
  local f epoch out cwd id preview
  local -a parts

  # --- Claude ---
  for f in $CLAUDE_DIR/*/*.jsonl(.N); do
    zstat -A epoch +mtime -- $f 2>/dev/null || continue
    out=$(jq -rs "$JQ_CLAUDE" -- "$f" 2>/dev/null) || continue
    parts=("${(@s:	:)out}")            # split on literal tab
    cwd=$parts[1]; preview=$parts[2]
    [[ -z $cwd ]] && cwd=$HOME
    # skip sessions whose original project dir no longer exists (set
    # AISS_SHOW_MISSING=1 to keep them)
    [[ -z $AISS_SHOW_MISSING && ! -d $cwd ]] && continue
    id=${f:t:r}                          # filename minus .jsonl
    _emit "$epoch" claude "$id" "$cwd" "$preview" "$f"
  done

  # --- Codex ---
  for f in $CODEX_DIR/**/rollout-*.jsonl(.N); do
    zstat -A epoch +mtime -- $f 2>/dev/null || continue
    out=$(jq -rs "$JQ_CODEX" -- "$f" 2>/dev/null) || continue
    parts=("${(@s:	:)out}")
    id=$parts[1]; cwd=$parts[2]; preview=$parts[3]
    [[ -z $id ]] && id=${f:t:r#rollout-*-}   # fallback: trailing uuid in name
    [[ -z $AISS_SHOW_MISSING && -n $cwd && ! -d $cwd ]] && continue
    _emit "$epoch" codex "$id" "$cwd" "$preview" "$f"
  done

  # --- Copilot CLI (~/.copilot/session-state/<uuid>/events.jsonl) ---
  for f in $COPILOT_DIR/*/events.jsonl(.N); do
    zstat -A epoch +mtime -- $f 2>/dev/null || continue
    out=$(jq -rs "$JQ_COPILOT" -- "$f" 2>/dev/null) || continue
    parts=("${(@s:	:)out}")
    cwd=$parts[1]; preview=$parts[2]
    [[ -z $AISS_SHOW_MISSING && -n $cwd && ! -d $cwd ]] && continue
    id=${f:h:t}                          # parent dir name = session UUID
    _emit "$epoch" copilot "$id" "$cwd" "$preview" "$f"
  done

  # --- Gemini (experimental: gemini-cli stores ~/.gemini/tmp/<hash>/logs.json) ---
  for f in $GEMINI_DIR/*/logs.json(.N); do
    zstat -A epoch +mtime -- $f 2>/dev/null || continue
    preview=$(jq -r 'try (map(select(.type=="user")) | .[0].message) // "" catch ""' -- "$f" 2>/dev/null)
    cwd=${f:h:t}
    _emit "$epoch" gemini "${f:h:t}" "$cwd" "${preview//[$'\n\t']/ }" "$f"
  done
}

preview() {
  local provider=$1 file=$2
  [[ -r $file ]] || { print -r -- "(file not found: $file)"; return 0; }
  local meta model mp ver branch cwd t0 t1 nu na
  case $provider in
    claude)
      meta=$(jq -rs "$JQ_CLAUDE_META" -- "$file" 2>/dev/null)
      IFS=$'\x1f' read -r model ver branch cwd t0 t1 nu na <<<"$meta"
      _aiss_header claude "$cwd" "$branch" "$model" "${ver:+Claude Code $ver}" "$t0" "$t1" "$nu" "$na"
      jq -rs "$JQ_CLAUDE_PREVIEW" -- "$file" 2>/dev/null
      ;;
    codex)
      meta=$(jq -rs "$JQ_CODEX_META" -- "$file" 2>/dev/null)
      IFS=$'\x1f' read -r model mp ver cwd t0 t1 nu na <<<"$meta"
      _aiss_header codex "$cwd" "" "$model" "codex ${ver}${mp:+ · $mp}" "$t0" "$t1" "$nu" "$na"
      jq -rs "$JQ_CODEX_PREVIEW" -- "$file" 2>/dev/null
      ;;
    copilot)
      meta=$(jq -rs "$JQ_COPILOT_META" -- "$file" 2>/dev/null)
      IFS=$'\x1f' read -r model ver branch cwd t0 t1 nu na <<<"$meta"
      _aiss_header copilot "$cwd" "$branch" "$model" "${ver:+Copilot CLI $ver}" "$t0" "$t1" "$nu" "$na"
      jq -rs "$JQ_COPILOT_PREVIEW" -- "$file" 2>/dev/null
      ;;
    gemini) jq -r '.[]? | "\u001b[1;36m" + (.type // "?") + "\u001b[0m\n" + (.message // (.|tostring)) + "\n"' -- "$file" 2>/dev/null ;;
    *)      cat -- "$file" ;;
  esac
}

case $1 in
  scan)    scan | sort -t$'\t' -k1,1rn | cut -f2- ;;
  preview) shift; preview "$@" ;;
  *) print -u2 "usage: aiss-helper.zsh {scan|preview <provider> <file>}"; return 2 ;;
esac
