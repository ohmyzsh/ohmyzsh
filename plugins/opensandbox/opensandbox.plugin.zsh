# opensandbox.plugin.zsh
# OpenSandbox CLI (`osb`) — aliases and cached, CLI-generated completion
# (pattern: plugins/uv).

# Return immediately if osb is not found
if (( ! ${+commands[osb]} )); then
  return
fi

# Aliases cover the core sandbox workflow: list -> create -> run.
alias osbl='osb sandbox list'
alias osbnew='osb sandbox create'
alias osbrun='osb command run'

# `osbsh [ID] [-w DIR]` wrapper: drops into an interactive terminal in a
# sandbox (`osb terminal`); without an ID the sole Running sandbox is
# auto-selected, else error on stderr + exit 1.

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

# If the completion file doesn't exist yet, we need to autoload it and
# bind it. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_osb" ]]; then
  typeset -g -A _comps
  autoload -Uz _osb
  _comps[osb]=_osb
fi

zmodload -F zsh/files b:zf_mv
() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/._osb"
  zf_mv -f -- =( _OSB_COMPLETE=zsh_source osb 2> /dev/null ) "$ZSH_CACHE_DIR/completions/_osb"
} &|
