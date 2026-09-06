# Return immediately if uv is not found
if (( ! ${+commands[uv]} )); then
  return
fi

alias uv="noglob uv"

alias uva='uv add'
alias uvexp='uv export --format requirements-txt --no-hashes --output-file requirements.txt --quiet'
alias uvi='uv init'
alias uvinw='uv init --no-workspace'
alias uvl='uv lock'
alias uvlr='uv lock --refresh'
alias uvlu='uv lock --upgrade'
alias uvp='uv pip'
alias uvpi='uv python install'
alias uvpl='uv python list'
alias uvpu='uv python uninstall'
alias uvpy='uv python'
alias uvpp='uv python pin'
alias uvr='uv run'
alias uvrm='uv remove'
alias uvs='uv sync'
alias uvsr='uv sync --refresh'
alias uvsu='uv sync --upgrade'
alias uvtr='uv tree'
alias uvup='uv self update'
alias uvv='uv venv'

# If the completion file doesn't exist yet, we need to autoload it and
# bind it. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_uv" ]]; then
  typeset -g -A _comps
  autoload -Uz _uv
  _comps[uv]=_uv
fi

if [[ ! -f "$ZSH_CACHE_DIR/completions/_uvx" ]]; then
  typeset -g -A _comps
  autoload -Uz _uvx
  _comps[uvx]=_uvx
fi

# uv and uvx are installed together (uvx is an alias to `uv tool run`)  
# Overwrites the file each time as completions might change with uv versions.
zmodload -F zsh/files b:zf_mv
() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/_uv"
  zf_mv -f -- =( uv generate-shell-completion zsh ) "$TMPPREFIX"
} &|
() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/_uvx"
  zf_mv -f -- =( uvx --generate-shell-completion zsh ) "$TMPPREFIX"
} &|
