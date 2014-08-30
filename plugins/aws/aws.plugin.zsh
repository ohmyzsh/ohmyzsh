_homebrew-installed() {
  type brew &> /dev/null
}

_awscli-homebrew-installed() {
  brew --prefix awscli &> /dev/null
}

export AWS_HOME=~/.aws

function agp {
  echo $AWS_DEFAULT_PROFILE
  
}
function asp {
  export AWS_DEFAULT_PROFILE=$1
    export RPROMPT="<aws:$AWS_DEFAULT_PROFILE>"
    
}
function aws_profiles {
  reply=($(grep profile $AWS_HOME/config|sed -e 's/.*profile \([a-zA-Z0-9_-]*\).*/\1/'))
}

compctl -K aws_profiles asp

if _homebrew-installed && _awscli-homebrew-installed ; then
  source $(brew --prefix)/opt/awscli/libexec/bin/aws_zsh_completer.sh
else
  source `which aws_zsh_completer.sh`
fi
