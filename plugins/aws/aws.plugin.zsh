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

  switch_profile $1

  export RPROMPT="<aws:$AWS_DEFAULT_PROFILE>$rprompt"
}

function acp {
  switch_profile $1
}

function switch_profile {
  export AWS_DEFAULT=$1
  export AWS_PROFILE=$1
}

function aws_profiles {
  reply=($(grep profile $AWS_HOME/config|sed -e 's/.*profile \([a-zA-Z0-9_-]*\).*/\1/'))
}

compctl -K aws_profiles asp
compctl -K aws_profiles acp

if _homebrew-installed && _awscli-homebrew-installed ; then
  _aws_zsh_completer_path=$(brew --prefix awscli)/libexec/bin/aws_zsh_completer.sh
else
  _aws_zsh_completer_path=$(which aws_zsh_completer.sh)
fi

[ -x $_aws_zsh_completer_path ] && source $_aws_zsh_completer_path
unset _aws_zsh_completer_path
