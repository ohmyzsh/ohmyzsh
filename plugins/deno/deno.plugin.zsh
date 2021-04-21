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
    || [[ ! -f $ZSH/completions/_deno ]]; then
    deno completions zsh > $ZSH/completions/_deno
    deno --version > $ZSH_CACHE_DIR/deno_version
  fi
fi

if (( $+commands[deno] )); then
  if ! (($fpath[(I)$ZSH/completions ])); then
    # When using some package managers, such as zinit, the $ZSH/completions
    # dir is not added to fpath
    fpath+=($ZSH/completions)
  fi
fi
