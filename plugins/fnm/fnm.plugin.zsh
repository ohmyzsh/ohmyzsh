if (( $+commands[fnm] )); then
  ver="$(fnm --version)"
  ver_file="$ZSH_CACHE_DIR/fnm_version"
  comp_file="$ZSH/plugins/fnm/_fnm"

  if [[ ! -f "$comp_file" || ! -f "$ver_file" || "$ver" != "$(< "$ver_file")" ]]; then
    fnm completions --shell=zsh >| "$comp_file"
    echo "$ver" >| "$ver_file"
  fi

  declare -A _comps
  autoload -Uz _fnm
  _comps[fnm]=_fnm

  unset ver ver_file comp_file
fi

