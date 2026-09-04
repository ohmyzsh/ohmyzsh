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
    unset SCW_PROFILE \
          SCW_DEFAULT_ORGANIZATION_ID \
          SCW_DEFAULT_PROJECT_ID \
          SCW_DEFAULT_REGION \
          SCW_DEFAULT_ZONE \
          SCW_API_URL \
          SCW_ACCESS_KEY \
          SCW_SECRET_KEY
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

  export SCW_PROFILE="$1"
  unset SCW_DEFAULT_ORGANIZATION_ID \
        SCW_DEFAULT_PROJECT_ID \
        SCW_DEFAULT_REGION \
        SCW_DEFAULT_ZONE \
        SCW_API_URL \
        SCW_ACCESS_KEY \
        SCW_SECRET_KEY

  function scw_export() {
    local -r scw_var="$1"
    local -r scw_key="$2"

    local -r scw_val="$(scw config get $scw_key)"
    if [[ -n "$scw_val" ]] && [[ "$scw_val" != "-" ]]; then
      eval "export ${scw_var}=$scw_val"
    fi
  }
  scw_export "SCW_DEFAULT_ORGANIZATION_ID" "default-organization-id"
  scw_export "SCW_DEFAULT_PROJECT_ID" "default-project-id"
  scw_export "SCW_DEFAULT_REGION" "default-region"
  scw_export "SCW_DEFAULT_ZONE" "default-zone"
  scw_export "SCW_API_URL" "api-url"
  if [[ "$SCW_EXPORT_TOKENS" = "true" ]]; then
    scw_export "SCW_ACCESS_KEY" "access-key"
    scw_export "SCW_SECRET_KEY" "secret-key"
  fi
}

function scw_profiles() {
  scw autocomplete complete zsh 5 -- scw config profile activate 2> /dev/null
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

function scw_upgrade() {
  if ! command -v curl &> /dev/null; then
    echo "[oh-my-zsh] scw upgrade requires curl, please install it"
    return
  fi

  local -r scw_path="$(which scw)"
  if ! [[ "$scw_path" =~ "^$HOME/.*" ]]; then
    echo "[oh-my-zsh] scw not installed in your HOME, upgrade cannot be performed"
    return
  fi
  local scw_version=""
  while read -r line; do
    if [[ "$line" =~ "^Version +([0-9.]+)\$" ]]; then
      scw_version="${match[1]}"
      break
    fi
  done <<< "$(scw version)"
  if [[ -z "$scw_version" ]]; then
    echo "[oh-my-zsh] cannot determine current scw version"
    return
  fi

  local -r shasums="$(curl --location --silent "https://github.com/scaleway/scaleway-cli/releases/latest/download/SHA256SUMS")"
  if [[ -z "$shasums" ]]; then
    echo "[oh-my-zsh] cannot download the list of binaries for the last release"
    return
  fi

  local -r kernel_name="${$(uname --kernel-name):l}"
  local -r arch="${$(uname --machine)//x86_64/amd64}"
  local binary_sha256=""
  local binary_name=""
  while read -r line; do
    if [[ "$line" =~ "^([0-9a-f]+)  (scaleway-cli_[0-9.]+_${kernel_name}_${arch})\$" ]]; then
      binary_sha256="${match[1]}"
      binary_name="${match[2]}"
      break
    fi
  done <<< "$shasums"
  if [[ -z "$binary_sha256" ]] || [[ -z "$binary_name" ]]; then
    echo "[oh-my-zsh] cannot find a scw binary for your computer"
    return
  fi
  if [[ "$binary_name" =~ "^scaleway-cli_${scw_version}_.*\$" ]]; then
    echo "[oh-my-zsh] current scw version is already the latest (v${scw_version})"
    return
  fi

  local -r binary_tmp="$(mktemp)"
  echo "[oh-my-zsh] downloading ${binary_name}..."
  curl --location --progress-bar "https://github.com/scaleway/scaleway-cli/releases/latest/download/${binary_name}" -o "$binary_tmp"
  if [[ $? -ne 0 ]]; then
    echo "[oh-my-zsh] cannot download the latest ${binary_name} release binary"
    rm -f "$binary_tmp"
    return
  fi
  if [[ "${$(sha256sum "$binary_tmp")%% *}" != "$binary_sha256" ]]; then
    echo "[oh-my-zsh] downloaded ${binary_name} binary has a wrong sha256sum"
    rm -f "$binary_tmp"
    return
  fi
  # Install new scw command and preserve original file permissions
  \cp --no-preserve=all --force "$binary_tmp" "$scw_path"
  echo "[oh-my-zsh] scw successfully updated"
  rm -f "$binary_tmp"
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
