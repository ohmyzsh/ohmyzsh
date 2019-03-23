function agp {
  echo $AWS_PROFILE
}

function asp {
  local rprompt=${RPROMPT/<aws:$AWS_PROFILE>/}

  export AWS_DEFAULT_PROFILE=$1
  export AWS_PROFILE=$1

  export RPROMPT="<aws:$AWS_PROFILE>$rprompt"
}

function aws_profiles {
  reply=($(grep '\[profile' "${AWS_CONFIG_FILE:-$HOME/.aws/config}"|sed -e 's/.*profile \([a-zA-Z0-9_\.-]*\).*/\1/'))
}
compctl -K aws_profiles asp


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
