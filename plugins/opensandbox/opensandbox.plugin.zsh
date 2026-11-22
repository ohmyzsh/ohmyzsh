# opensandbox.plugin.zsh
# Aliases + wrapper + completion bootstrap for the OpenSandbox CLI (`osb`).
#
# Layout:
#   - This file: guard, aliases, `osbsh` wrapper, completion bootstrap.
#   - `plugins/opensandbox/_osb` (on $fpath): the `_osb`
#     completion function with dynamic sandbox IDs; delegates to the
#     generated Click completion (`_osb_click`) when the cache is loaded.

# Guard: silent no-op when the CLI is missing.
(( $+commands[osb] )) || return 0

# Completion bootstrap (kubectl-style, see plugins/kubectl/kubectl.plugin.zsh):
#
# 1) Generate the Click completion in the background into
#    $ZSH_CACHE_DIR/completions/_osb_click. The output is written via a
#    private temp file and moved into place with zf_mv, so a half-written
#    file can never end up on disk. The file name `_osb_click` is chosen
#    deliberately: its `#compdef osb` header makes compinit register a
#    fallback binding, but the explicit `compdef _osb osb` below runs
#    later and wins.
# 2) If the cache already exists (second and later shell starts), source
#    it: this loads the generated `_osb_completion` function into the
#    function space. The generated file ends with an unguarded
#    `compdef _osb_completion osb` (inside its own if/else), which errors
#    ("command not found") in any context where compinit has not run yet.
#    Pre-process the string so that call is guarded; the file is
#    re-generated on every shell start anyway.
# 3) Source the repo-local `_osb` completion file (same directory as this
#    plugin). It defines the entry-point completer `_osb` plus its
#    helpers. Sourcing (instead of `autoload -U _osb`) is deliberate:
#    with autoload, the first completion invocation of a multi-function
#    file can be silently dropped on this system's zsh 5.9 (the file is
#    read but the requested function's body does not execute on call
#    1; it only runs on call 2), which would make the first TAB of a
#    new shell return no candidates. Sourcing defines every function
#    up front and makes the first TAB work.
# 4) Register `_osb` as the completer for `osb`. `compdef` is a function
#    defined by compinit (not an external command), so the availability
#    test is `$+functions[compdef]`. OMZ loads plugins after compinit,
#    so this also overrides any binding compinit derived from the cache
#    file's `#compdef osb` header.
#
# The bootstrap only runs when $ZSH_CACHE_DIR is set (i.e. under OMZ or
# an equivalent layout); sourced outside that context the cache step is
# a no-op and the plugin stays silent.

if [[ -n "${ZSH_CACHE_DIR:-}" && -d "$ZSH_CACHE_DIR" ]]; then
  mkdir -p -- "$ZSH_CACHE_DIR/completions" 2>/dev/null
  zmodload -F zsh/files b:zf_mv
  () {
    zf_mv -f -- =( _OSB_COMPLETE=zsh_source osb 2> /dev/null ) \
      "$ZSH_CACHE_DIR/completions/_osb_click"
  } &|

  if [[ -f "$ZSH_CACHE_DIR/completions/_osb_click" ]]; then
    local _osb_click_cache _osb_click_guard
    _osb_click_guard='if (( $+commands[compdef] )); then compdef _osb_completion osb; fi'
    _osb_click_cache=$(< "$ZSH_CACHE_DIR/completions/_osb_click")
    # Guard the trailing `compdef _osb_completion osb` (see above).
    _osb_click_cache=${_osb_click_cache/compdef _osb_completion osb/"$_osb_click_guard"}
    source <(printf '%s\n' "$_osb_click_cache")
    unset _osb_click_cache _osb_click_guard
  fi
fi

# Repo-local completion entry point (always available, defines _osb +
# helpers; see comment above for why this is `source`d, not autoloaded).
[[ -f "${0:A:h}/_osb" ]] && source "${0:A:h}/_osb"

if (( $+functions[compdef] )) || (( $+commands[compdef] )); then
  compdef _osb osb
fi

# Aliases cover the common sandbox workflow: create -> run -> file
# transfer -> endpoint -> kill. One alias per frequently typed command;
# everything else stays available through completion and `osb help`.

# Sandbox lifecycle
alias osbl='osb sandbox list'
alias osbnew='osb sandbox create'
alias osbkill='osb sandbox kill'
alias osbres='osb sandbox resume'
alias osbpause='osb sandbox pause'

# Command execution
alias osbrun='osb command run'

# File operations
alias osbup='osb file upload'
alias osbdown='osb file download'

# Endpoint access
alias osbep='osb sandbox endpoint'

# `osbsh [ID] [-w DIR]` (wrapper defined below) drops into an interactive
# terminal in a sandbox (`osb terminal`): with an explicit ID, or the sole
# Running sandbox auto-selected when none is given.

# osbsh [ID] [-w DIR]
# Drop into an interactive terminal in a sandbox.
# Without an ID: auto-select the single Running sandbox; 0 or more than 1
# Running sandbox -> error on stderr, exit 1.
osbsh() {
  local id="" dir=""

  while (( $# )); do
    case "$1" in
      -w)
        dir="${2:-}"
        shift
        (( $# )) && shift
        ;;
      *)
        id="$1"
        shift
        ;;
    esac
  done

  if [[ -z "$id" ]]; then
    # Auto-select: exactly one Running sandbox required.
    local -a ids=()
    local line
    for line in "${(@f)$( _osb_running_sandbox_ids )}"; do
      [[ -n "$line" ]] && ids+=("$line")
    done

    if (( ${#ids} == 0 )); then
      print -u2 "osbsh: no Running sandbox found (use: osbsh <ID>)"
      return 1
    fi
    if (( ${#ids} > 1 )); then
      print -u2 "osbsh: multiple Running sandboxes found, specify an ID:"
      print -u2 -l -- "  ${ids[@]}"
      return 1
    fi
    id="${ids[1]}"
  fi

  if [[ -n "$dir" ]]; then
    osb terminal "$id" -w "$dir"
  else
    osb terminal "$id"
  fi
}

# _osb_running_sandbox_ids
# Print one Running sandbox ID per line (empty output on any error).
# jq primary, python3 fallback.
_osb_running_sandbox_ids() {
  local json
  json=$(osb sandbox list -o json -s Running 2>/dev/null) || return 0
  [[ -n "$json" ]] || return 0

  if (( $+commands[jq] )); then
    jq -r '.items[] | select(.id != null) | .id' <<< "$json" 2>/dev/null
  elif (( $+commands[python3] )); then
    python3 -c '
import json, sys
try:
    data = json.load(sys.stdin)
    for item in data.get("items", []):
        print(item.get("id", ""))
except Exception:
    pass
' <<< "$json" 2>/dev/null
  fi
}
