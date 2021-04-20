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
autoload -U add-zsh-hook
_deno_completion_auto_update() {
  if [[ $+commands[deno] -eq 0 \
    && ( ! -r "$ZSH_CACHE_DIR/deno_version" \
    || "$(deno --version)" != "$(< "$ZSH_CACHE_DIR/deno_version")" )]]; then
      mkdir -p $ZSH/completions
      deno completions zsh > $ZSH/completions/_deno
      deno --version > $ZSH_CACHE_DIR/deno_version
  fi
}

PERIOD=86400 # 24 hours
add-zsh-hook periodic _deno_completion_auto_update

if (( $+commands[deno] )); then
  if [[ ! -f "$ZSH/completions/_deno" ]]; then
    mkdir -p $ZSH/completions
    deno completions zsh > $ZSH/completions/_deno
    deno --version > $ZSH_CACHE_DIR/deno_version
  fi

  if ! (($fpath[(I)$ZSH/completions ])); then
    # When using some package managers, such as zinit, the $ZSH/completions
    # dir is not added to fpath
    fpath+=($ZSH/completions)
  fi
fi
