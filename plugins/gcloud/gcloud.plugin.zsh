#####################################################
# gcloud plugin for oh-my-zsh                       #
# Author: Ian Chesal (github.com/ianchesal)         #
#####################################################

if [[ -z "${CLOUDSDK_HOME}" ]]; then
  search_locations=(
    "$HOME/google-cloud-sdk"
    "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk"
    "/usr/share/google-cloud-sdk"
    "/snap/google-cloud-sdk/current"
    "/usr/lib64/google-cloud-sdk/"
    "/opt/google-cloud-sdk"
  )

  for gcloud_sdk_location in $search_locations; do
    if [[ -d "${gcloud_sdk_location}" ]]; then
      CLOUDSDK_HOME="${gcloud_sdk_location}"
      break
    fi
  done
fi

if (( ${+CLOUDSDK_HOME} )); then
  if (( ! $+commands[gcloud] )); then
    # Only source this if GCloud isn't already on the path
    if [[ -f "${CLOUDSDK_HOME}/path.zsh.inc" ]]; then
      source "${CLOUDSDK_HOME}/path.zsh.inc"
    fi
  fi
  source "${CLOUDSDK_HOME}/completion.zsh.inc"
  export CLOUDSDK_HOME
fi
