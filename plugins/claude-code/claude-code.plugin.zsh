# Claude Code - Oh My Zsh Plugin
# Aliases and helpers for the Claude Code CLI
# https://github.com/anthropics/claude-code

# Prerequisite check

if ! (( $+commands[claude] )); then
  print "zsh claude-code plugin: claude not found. Please install Claude Code before using this plugin." >&2
  return 1
fi

# Configuration variables

# Default model for clm function (e.g., opus, sonnet, haiku, or full model ID)
: ${ZSH_CLAUDE_DEFAULT_MODEL:=}
# Default reasoning effort level (low, medium, high, max)
: ${ZSH_CLAUDE_DEFAULT_EFFORT:=}
# Default permission mode for claude sessions (choices: "acceptEdits", "bypassPermissions", "default", "dontAsk", "plan", "auto")
: ${ZSH_CLAUDE_DEFAULT_PERMISSION_MODE:=}
# Auto-resume last conversation on new shell start (true/false)
: ${ZSH_CLAUDE_AUTO_CONTINUE:=false}

# Core aliases

alias cl='_claude_with_defaults'
alias clc='_claude_with_defaults --continue'
alias clr='_claude_with_defaults --resume'
alias clp='_claude_with_defaults -p'
alias clv='claude --version'
alias clu='claude update'

# Session aliases

alias cln='_claude_with_defaults -n'
alias clw='_claude_with_defaults -w'
alias clfork='_claude_with_defaults --fork-session'

# Auth aliases

alias clas='claude auth status'
alias clal='claude auth login'
alias clao='claude auth logout'

# Config aliases

alias clmcp='claude mcp'
alias clag='claude agents'

# Model & effort aliases

function clm() {
  local model="${1:-${ZSH_CLAUDE_DEFAULT_MODEL}}"
  if [[ -z "$model" ]]; then
    print "Usage: clm <model>  (opus, sonnet, haiku, or full model ID)" >&2
    return 1
  fi
  shift 2>/dev/null
  local -a args=()
  [[ -n "$ZSH_CLAUDE_DEFAULT_EFFORT" ]] && args+=(--effort "$ZSH_CLAUDE_DEFAULT_EFFORT")
  [[ -n "$ZSH_CLAUDE_DEFAULT_PERMISSION_MODE" ]] && args+=(--permission-mode "$ZSH_CLAUDE_DEFAULT_PERMISSION_MODE")
  claude --model "$model" "${args[@]}" "$@"
}

function cle() {
  local effort="${1:-${ZSH_CLAUDE_DEFAULT_EFFORT}}"
  if [[ -z "$effort" ]]; then
    print "Usage: cle <effort>  (low, medium, high, max)" >&2
    return 1
  fi
  shift 2>/dev/null
  local -a args=()
  [[ -n "$ZSH_CLAUDE_DEFAULT_MODEL" ]] && args+=(--model "$ZSH_CLAUDE_DEFAULT_MODEL")
  [[ -n "$ZSH_CLAUDE_DEFAULT_PERMISSION_MODE" ]] && args+=(--permission-mode "$ZSH_CLAUDE_DEFAULT_PERMISSION_MODE")
  claude --effort "$effort" "${args[@]}" "$@"
}

# Channel aliases

alias clch-tg='_claude_with_defaults --channels plugin:telegram@claude-plugins-official'
alias clch-dc='_claude_with_defaults --channels plugin:discord@claude-plugins-official'

function clch() {
  if [[ -z "$1" ]]; then
    print "Usage: clch <channel-spec> [claude-args...]" >&2
    print "  e.g. clch plugin:telegram@claude-plugins-official" >&2
    return 1
  fi
  local channel="$1"
  shift
  _claude_with_defaults --channels "$channel" "$@"
}

# Helper functions

# Directory session: create or resume a session named after the current directory
# Similar to tmux's tds alias
function clds() {
  local dir="${PWD##*/}"
  [[ "$PWD" == "$HOME" ]] && dir="HOME"
  [[ "$PWD" == "/" ]] && dir="ROOT"
  _claude_with_defaults --resume "$dir" "$@" 2>/dev/null || _claude_with_defaults -n "$dir" "$@"
}

# Resume from a PR number
function clfp() {
  if [[ -z "$1" ]]; then
    print "Usage: clfp <pr-number>" >&2
    return 1
  fi
  claude --from-pr "$1"
}

# Start claude with default config variables applied
function _claude_with_defaults() {
  local -a args
  args=()

  [[ -n "$ZSH_CLAUDE_DEFAULT_MODEL" ]] && args+=(--model "$ZSH_CLAUDE_DEFAULT_MODEL")
  [[ -n "$ZSH_CLAUDE_DEFAULT_EFFORT" ]] && args+=(--effort "$ZSH_CLAUDE_DEFAULT_EFFORT")
  [[ -n "$ZSH_CLAUDE_DEFAULT_PERMISSION_MODE" ]] && args+=(--permission-mode "$ZSH_CLAUDE_DEFAULT_PERMISSION_MODE")

  claude "${args[@]}" "$@"
}

# Tab completion

function _claude_code_models() {
  local -a models
  models=(
    'opus:Claude Opus (most capable)'
    'sonnet:Claude Sonnet (balanced)'
    'haiku:Claude Haiku (fastest)'
  )
  _describe 'model' models
}

function _claude_code_efforts() {
  local -a efforts
  efforts=(
    'low:Minimal reasoning'
    'medium:Balanced reasoning'
    'high:Deep reasoning'
    'max:Maximum reasoning depth'
  )
  _describe 'effort' efforts
}

function _claude_code_permission_modes() {
  local -a modes
  modes=(
    'plan:Plan mode - confirm before actions'
    'auto:Auto mode - approve safe actions'
    'manual:Manual mode - approve everything'
  )
  _describe 'permission-mode' modes
}

function _clm() {
  _arguments '1:model:_claude_code_models' '*::args:'
}

function _cle() {
  _arguments '1:effort:_claude_code_efforts' '*::args:'
}

compdef _clm clm
compdef _cle cle

# Auto-continue on shell start

if [[ "$ZSH_CLAUDE_AUTO_CONTINUE" == "true" && -z "$CLAUDECODE" ]]; then
  claude --continue 2>/dev/null
fi
