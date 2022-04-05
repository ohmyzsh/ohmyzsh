# ALIASES
alias db='deno bundle'
alias dc='deno compile'
alias dca='deno cache'
alias dfmt='deno fmt'
alias dh='deno help'
alias dli='deno lint'
alias drn='deno run'
alias drA='deno run -A'
alias drw='deno run --watch'
alias dts='deno test'
alias dup='deno upgrade'

# COMPLETION FUNCTION
if (( ! $+commands[deno] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `deno`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_deno" ]]; then
  typeset -g -A _comps
  autoload -Uz _deno
  _comps[deno]=_deno
fi

deno completions zsh >| "$ZSH_CACHE_DIR/completions/_deno" &|
