_homebrew-installed() {
  type brew &> /dev/null
  _xit=$?
  if [ $_xit -eq 0 ];then
        # ok , we have brew installed
        # speculatively we check default brew prefix
        if [ -h  /usr/local/opt/awscli ];then
                _brew_prefix="/usr/local/opt/awscli"
        else
                # ok , it is not default prefix
                # this call to brew is expensive ( about 400 ms ), so at least let's make it only once
                _brew_prefix=$(brew --prefix awscli)
        fi
        return 0
   else
        return $_xit
   fi
}

_awscli-homebrew-installed() {
  [ -r $_brew_prefix/libexec/bin/aws_zsh_completer.sh ] &> /dev/null
}

function aws_get_profile {
  echo $AWS_PROFILE
}

function aws_set_profile {
  export AWS_DEFAULT_PROFILE=$1
  export AWS_PROFILE=$1
}

function aws_unset_profile {
  export AWS_DEFAULT_PROFILE=
  export AWS_PROFILE=
}

function aws_profile_prompt_info() {
  [[ -n ${AWS_PROFILE} ]] || return
  echo "${ZSH_THEME_AWS_PREFIX:=[}${AWS_PROFILE:t}${ZSH_THEME_AWS_SUFFIX:=]}"
}

function aws_profiles {
  reply=($(grep '\[profile' "${AWS_CONFIG_FILE:-$HOME/.aws/config}"|sed -e 's/.*profile \([a-zA-Z0-9_\.-]*\).*/\1/'))
}
compctl -K aws_profiles aws_set_profile

if which aws_zsh_completer.sh &>/dev/null; then
  _aws_zsh_completer_path=$(which aws_zsh_completer.sh 2>/dev/null)
elif _homebrew-installed && _awscli-homebrew-installed; then
  _aws_zsh_completer_path=$_brew_prefix/libexec/bin/aws_zsh_completer.sh
fi

[ -n "$_aws_zsh_completer_path" ] && [ -x $_aws_zsh_completer_path ] && source $_aws_zsh_completer_path
unset _aws_zsh_completer_path
