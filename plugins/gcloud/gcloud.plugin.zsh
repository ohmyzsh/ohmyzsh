#####################################################
# gcloud plugin for oh-my-zsh                       #
# Author: Ian Chesal (github.com/ianchesal)         #
#####################################################

if [[ -z "${CLOUDSDK_HOME}" ]]; then
  search_locations=(
    "$HOME/google-cloud-sdk"
    "/usr/local/share/google-cloud-sdk"
    "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk"
    "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk"
    "/opt/homebrew/share/google-cloud-sdk"
    "/usr/share/google-cloud-sdk"
    "/snap/google-cloud-sdk/current"
    "/snap/google-cloud-cli/current"
    "/usr/lib/google-cloud-sdk"
    "/usr/lib64/google-cloud-sdk"
    "/opt/google-cloud-sdk"
    "/opt/google-cloud-cli"
    "/opt/local/libexec/google-cloud-sdk"
    "$HOME/.asdf/installs/gcloud/*/"
  )

  for gcloud_sdk_location in $search_locations; do
    if [[ -d "${gcloud_sdk_location}" ]]; then
      CLOUDSDK_HOME="${gcloud_sdk_location}"
      break
    fi
  done
  unset search_locations gcloud_sdk_location
fi

if (( ${+CLOUDSDK_HOME} )); then
  # Source path file
  if [[ -f "${CLOUDSDK_HOME}/path.zsh.inc" ]]; then
    source "${CLOUDSDK_HOME}/path.zsh.inc"
  fi

  # Look for completion file in different paths
  for comp_file (
    "${CLOUDSDK_HOME}/completion.zsh.inc"             # default location
    "/usr/share/google-cloud-sdk/completion.zsh.inc"  # apt-based location
  ); do
    if [[ -f "${comp_file}" ]]; then
      source "${comp_file}"
      break
    fi
  done
  unset comp_file

  export CLOUDSDK_HOME
fi
