# ALIASES
alias db='deno bundle'
alias dc='deno compile'
alias dca='deno cache'
alias dfmt='deno fmt'
alias dh='deno help'
alias dli='deno lint'
alias drn='deno run'
alias drw='deno run --watch'
alias dts='deno test'
alias dup='deno upgrade'

# COMPLETION FUNCTION
if (( $+commands[deno] )); then
  if [[ ! -f $ZSH_CACHE_DIR/deno_version ]] \
    || [[ "$(deno --version)" != "$(< "$ZSH_CACHE_DIR/deno_version")" ]] \
    || [[ ! -f $ZSH/plugins/deno/_deno ]]; then
    deno completions zsh > $ZSH/plugins/deno/_deno
    deno --version > $ZSH_CACHE_DIR/deno_version
  fi
  autoload -Uz _deno
  _comps[deno]=_deno
fi
