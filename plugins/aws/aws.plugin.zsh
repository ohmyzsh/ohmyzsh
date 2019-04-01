# AWS profile selection

function agp {
  echo $AWS_PROFILE
}

function asp {
  export AWS_DEFAULT_PROFILE=$1
  export AWS_PROFILE=$1
  export AWS_EB_PROFILE=$1

  if [[ -z "$1" ]]; then
    echo AWS profile cleared.
  fi
}

function aws_change_access_key {
  if [[ -z "$1" ]] then
    echo "usage: $0 <profile>"
    return 1
  fi

  echo Insert the credentials when asked.
  asp "$1"
  aws iam create-access-key
  aws configure --profile "$1"

  echo You can now safely delete the old access key running \`aws iam delete-access-key --access-key-id ID\`
  echo Your current keys are:
  aws iam list-access-keys
}

function aws_profiles {
  reply=($(grep '\[profile' "${AWS_CONFIG_FILE:-$HOME/.aws/config}"|sed -e 's/.*profile \([a-zA-Z0-9_\.-]*\).*/\1/'))
}
compctl -K aws_profiles asp aws_change_access_key


# AWS prompt

function aws_prompt_info() {
  [[ -z $AWS_PROFILE ]] && return
  echo "${ZSH_THEME_AWS_PREFIX:=<aws:}${AWS_PROFILE}${ZSH_THEME_AWS_SUFFIX:=>}"
}

if [ "$SHOW_AWS_PROMPT" != false ]; then
  export RPROMPT='$(aws_prompt_info)'"$RPROMPT"
fi


# Load awscli completions

_awscli-homebrew-installed() {
  # check if Homebrew is installed
  (( $+commands[brew] )) || return 1

  # speculatively check default brew prefix
  if [ -h /usr/local/opt/awscli ]; then
    _brew_prefix=/usr/local/opt/awscli
  else
    # ok, it is not in the default prefix
    # this call to brew is expensive (about 400 ms), so at least let's make it only once
    _brew_prefix=$(brew --prefix awscli)
  fi
}

# get aws_zsh_completer.sh location from $PATH
_aws_zsh_completer_path="$commands[aws_zsh_completer.sh]"

# otherwise check if installed via Homebrew
if [[ -z $_aws_zsh_completer_path ]] && _awscli-homebrew-installed; then
  _aws_zsh_completer_path=$_brew_prefix/libexec/bin/aws_zsh_completer.sh
else
  _aws_zsh_completer_path=/usr/share/zsh/site-functions/aws_zsh_completer.sh
fi

[[ -r $_aws_zsh_completer_path ]] && source $_aws_zsh_completer_path
unset _aws_zsh_completer_path _brew_prefix
