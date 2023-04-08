# AZ Get Subscritions
function azgs() {
  az account show --output tsv --query 'name' 2>/dev/null
}

# AZ Subscription Selection
alias azss="az account set --subscription"


function az_subscriptions() {
  az account list  --all --output tsv --query '[*].name' 2> /dev/null
}

function _az_subscriptions() {
  reply=($(az_subscriptions))
}
compctl -K _az_subscriptions azss

# Azure prompt
function azure_prompt_info() {
  [[ ! -f "${AZURE_CONFIG_DIR:-$HOME/.azure}/azureProfile.json" ]] && return
  # azgs is too expensive, if we have jq, we enable the prompt
  (( $+commands[jq] )) || return 1
  azgs=$(jq -r '.subscriptions[] | select(.isDefault==true) .name' "${AZURE_CONFIG_DIR:-$HOME/.azure}/azureProfile.json")
  echo "${ZSH_THEME_AZURE_PREFIX:=<az:}${azgs}${ZSH_THEME_AZURE_SUFFIX:=>}"
}


# Load az completions
function _az-homebrew-installed() {
  # check if Homebrew is installed
  (( $+commands[brew] )) || return 1

  # speculatively check default brew prefix
  if [[ -d /usr/local ]]; then
    _brew_prefix=/usr/local
  elif [[ -d /opt/homebrew ]]; then
    _brew_prefix=/opt/homebrew
  else
    # ok, it is not in the default prefix
    # this call to brew is expensive (about 400 ms), so at least let's make it only once
    _brew_prefix=$(brew --prefix)
  fi
}


# get az.completion.sh location from $PATH
_az_zsh_completer_path="$commands[az_zsh_completer.sh]"

# otherwise check common locations
if [[ -z $_az_zsh_completer_path ]]; then
  # Homebrew
  if _az-homebrew-installed; then
    _az_zsh_completer_path=$_brew_prefix/etc/bash_completion.d/az
  # Linux
  else
    _az_zsh_completer_path=/etc/bash_completion.d/azure-cli
  fi
fi

[[ -r $_az_zsh_completer_path ]] && autoload -U +X bashcompinit && bashcompinit && source $_az_zsh_completer_path
unset _az_zsh_completer_path _brew_prefix
