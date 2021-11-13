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
  # remove old generated completion file
  command rm -f "${0:A:h}/_deno"

  ver="$(deno --version)"
  ver_file="$ZSH_CACHE_DIR/deno_version"
  comp_file="$ZSH_CACHE_DIR/completions/_deno"

  mkdir -p "${comp_file:h}"
  (( ${fpath[(Ie)${comp_file:h}]} )) || fpath=("${comp_file:h}" $fpath)

  if [[ ! -f "$comp_file" || ! -f "$ver_file" || "$ver" != "$(< "$ver_file")" ]]; then
    deno completions zsh >| "$comp_file"
    echo "$ver" >| "$ver_file"
  fi

  declare -A _comps
  autoload -Uz _deno
  _comps[deno]=_deno

  unset ver ver_file comp_file
fi
