# Return immediately if uv is not found
if (( ! ${+commands[uv]} )); then
  return
fi

alias uva='uv add'
alias uvexp='uv export --format requirements-txt --no-hashes --output-file requirements.txt --quiet'
alias uvl='uv lock'
alias uvlr='uv lock --refresh'
alias uvlu='uv lock --upgrade'
alias uvp='uv pip'
alias uvpy='uv python'
alias uvr='uv run'
alias uvrm='uv remove'
alias uvs='uv sync'
alias uvsr='uv sync --refresh'
alias uvsu='uv sync --upgrade'
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
uv generate-shell-completion zsh >| "$ZSH_CACHE_DIR/completions/_uv" &|
uvx --generate-shell-completion zsh >| "$ZSH_CACHE_DIR/completions/_uvx" &|
