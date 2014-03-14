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
source `which aws_zsh_completer.sh`
