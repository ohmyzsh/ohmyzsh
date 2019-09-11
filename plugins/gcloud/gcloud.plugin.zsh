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
  )

  for gcloud_sdk_location in $search_locations; do
    if [[ -d "${gcloud_sdk_location}" ]]; then
      CLOUDSDK_HOME="${gcloud_sdk_location}"
      break
    fi
  done
fi

if (( ${+CLOUDSDK_HOME} )); then
  if ! type "${CLOUDSDK_HOME}/bin/gcloud" > /dev/null; then
    # Only source this if GCloud isn't already on the path
    source "${CLOUDSDK_HOME}/path.zsh.inc"
  fi
  source "${CLOUDSDK_HOME}/completion.zsh.inc"
  export CLOUDSDK_HOME
fi
