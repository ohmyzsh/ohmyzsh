if (( ! $+commands[scw] )); then
  return
fi

_scw () {
  output=($(scw autocomplete complete zsh -- ${CURRENT} ${words}))
  opts=('-S' ' ')
  if [[ $output == *= ]]; then
    opts=('-S' '')
  fi
  compadd "${opts[@]}" -- "${output[@]}"
}

compdef _scw scw

function sgp() {
  echo "$SCW_PROFILE"
}

# SCW profile selection
function ssp() {
  if [[ -z "$1" ]]; then
    unset SCW_PROFILE
    echo SCW profile cleared.
    return
  fi

  local -a available_profiles
  available_profiles=($(scw_profiles))
  if [[ -z "${available_profiles[(r)$1]}" ]]; then
    echo "${fg[red]}Profile '$1' not found in '$(scw_config_path)'" >&2
    echo "Available profiles: ${(j:, :)available_profiles:-no profiles found}${reset_color}" >&2
    return 1
  fi

  export SCW_PROFILE=$1
}

function scw_profiles() {
  scw autocomplete complete zsh 3 -- scw --profile 2> /dev/null
}

function scw_config_path() {
  if [[ -v SCW_CONFIG_PATH ]]; then
    echo "$SCW_CONFIG_PATH"
    return
  fi

  for f in "$XDG_CONFIG_HOME/scw/config.yaml" \
           "$HOME/.config/scw/config.yaml"    \
           "$USERPROFILE/.config/scw/config.yaml"; do
    if [[ -f "$f" ]]; then
      echo "$f"
      return
    fi
  done
}

function _scw_profiles() {
  reply=($(scw_profiles))
}
compctl -K _scw_profiles ssp

function scw_prompt_info() {
  local _scw_to_show

  if [[ -n "$SCW_PROFILE" ]]; then
    _scw_to_show+="${ZSH_THEME_SCW_PROFILE_PREFIX="<scw:"}${SCW_PROFILE}${ZSH_THEME_SCW_PROFILE_SUFFIX=">"}"
  fi

  echo "$_scw_to_show"
}

if [[ "$SHOW_SCW_PROMPT" != false && "$RPROMPT" != *'$(scw_prompt_info)'* ]]; then
  RPROMPT='$(scw_prompt_info)'"$RPROMPT"
fi
