if [[ -z "$SDKMAN_DIR" ]]; then
  if [[ -d "$HOME/.sdkman" ]]; then
    export SDKMAN_DIR="$HOME/.sdkman"
  else
    export SDKMAN_DIR="$(brew --prefix sdkman-cli)/libexec" || echo "Cannot find SDKMAN!"
  fi
fi
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
