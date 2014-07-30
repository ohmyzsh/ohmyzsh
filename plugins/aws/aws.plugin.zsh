_homebrew-installed() {
  type brew &> /dev/null
}

_awscli-homebrew-installed() {
  brew list awscli &> /dev/null
}

export AWS_HOME=~/.aws

function agp {
  echo $AWS_DEFAULT_PROFILE
}

function asp {
  local rprompt=${RPROMPT/<aws:$(agp)>/}

  export AWS_DEFAULT_PROFILE=$1
  export AWS_PROFILE=$1

  export RPROMPT="<aws:$AWS_DEFAULT_PROFILE>$rprompt"
}

function aws_profiles {
  reply=($(grep profile $AWS_HOME/config|sed -e 's/.*profile \([a-zA-Z0-9_-]*\).*/\1/'))
}

function aws_change_access_key {
  if [[ "x$1" == "x" ]] then
    echo "usage: $0 <profile.name>"
    return 1
  else
    echo "Insert the credentials when asked."
    asp $1
    aws iam create-access-key
    aws configure --profile $1
    echo "You can now safely delete the old access key running 'aws iam delete-access-key --access-key-id ID'"
    echo "Your current keys are:"
    aws iam list-access-keys
  fi
}

compctl -K aws_profiles asp aws_change_access_key

if _homebrew-installed && _awscli-homebrew-installed ; then
  _aws_zsh_completer_path=$(brew --prefix awscli)/libexec/bin/aws_zsh_completer.sh
else
  _aws_zsh_completer_path=$(which aws_zsh_completer.sh)
fi

[ -x $_aws_zsh_completer_path ] && source $_aws_zsh_completer_path
unset _aws_zsh_completer_path
