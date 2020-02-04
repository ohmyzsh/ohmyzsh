function agp() {
  echo $AWS_PROFILE
}

# AWS profile selection
function asp() {
  if [[ -z "$1" ]]; then
    unset AWS_DEFAULT_PROFILE AWS_PROFILE AWS_EB_PROFILE
    echo AWS profile cleared.
    return
  fi

  local -a available_profiles
  available_profiles=($(aws_profiles))
  if [[ -z "${available_profiles[(r)$1]}" ]]; then
    echo "${fg[red]}Profile '$1' not found in '${AWS_CONFIG_FILE:-$HOME/.aws/config}'" >&2
    echo "Available profiles: ${(j:, :)available_profiles:-no profiles found}${reset_color}" >&2
    return 1
  fi

  export AWS_DEFAULT_PROFILE=$1
  export AWS_PROFILE=$1
  export AWS_EB_PROFILE=$1
}

function aws_change_access_key() {
  if [[ -z "$1" ]]; then
    echo "usage: $0 <profile>"
    return 1
  fi

  echo Insert the credentials when asked.
  asp "$1" || return 1
  aws iam create-access-key
  aws configure --profile "$1"

  echo You can now safely delete the old access key running \`aws iam delete-access-key --access-key-id ID\`
  echo Your current keys are:
  aws iam list-access-keys
}

function aws_profiles() {
  [[ -r "${AWS_CONFIG_FILE:-$HOME/.aws/config}" ]] || return 1
  grep '\[profile' "${AWS_CONFIG_FILE:-$HOME/.aws/config}"|sed -e 's/.*profile \([a-zA-Z0-9_\.-]*\).*/\1/'
}

function _aws_profiles() {
  reply=($(aws_profiles))
}

# AWS Assume Role
function aar() {

    if [[ -z "$1" ]]; then
        unset AWS_DEFAULT_PROFILE AWS_PROFILE AWS_EB_PROFILE
        echo AWS profile cleared.
        return
    fi

    local aws_profile_name=${1}

    local role_arn=$(aws configure --profile ${aws_profile_name} get role_arn)

    if [[ -z "$role_arn" ]]; then
        echo Role ARN for profile \(${aws_profile_name}\) cannot be found.
        echo Please set the \'role_arn\' attribute on the profile.
        return 1
    fi

    local session_name="${aws_profile_name}-session"

    local credentials_output=$(aws sts assume-role --role-arn ${role_arn} --role-session-name ${session_name} --query '[Credentials.AccessKeyId,Credentials.SecretAccessKey,Credentials.SessionToken]' --output text | tr "\t" "\n")

    local credentials=("${(f)credentials_output}")

    local access_key_id=${credentials[1]}
    local secret_access_key=${credentials[2]}
    local session_token=${credentials[3]}

    aws configure --profile ${aws_profile_name} set aws_access_key_id ${access_key_id}
    aws configure --profile ${aws_profile_name} set aws_secret_access_key ${secret_access_key}
    aws configure --profile ${aws_profile_name} set aws_session_token ${session_token}

    export AWS_ACCESS_KEY_ID=${access_key_id}
    export AWS_SECRET_ACCESS_KEY=${secret_access_key}
    export AWS_SESSION_TOKEN=${session_token}

    export AWS_DEFAULT_PROFILE=${aws_profile_name}
    export AWS_PROFILE=${aws_profile_name}
    export AWS_EB_PROFILE=${aws_profile_name}

    echo Credentials set for AWS profile \(${aws_profile_name}\)
}

compctl -K _aws_profiles asp aws_change_access_key aar

# AWS prompt
function aws_prompt_info() {
  [[ -z $AWS_PROFILE ]] && return
  echo "${ZSH_THEME_AWS_PREFIX:=<aws:}${AWS_PROFILE}${ZSH_THEME_AWS_SUFFIX:=>}"
}

if [ "$SHOW_AWS_PROMPT" != false ]; then
  RPROMPT='$(aws_prompt_info)'"$RPROMPT"
fi


# Load awscli completions

function _awscli-homebrew-installed() {
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

# otherwise check common locations
if [[ -z $_aws_zsh_completer_path ]]; then
  # Homebrew
  if _awscli-homebrew-installed; then
    _aws_zsh_completer_path=$_brew_prefix/libexec/bin/aws_zsh_completer.sh
  # Ubuntu
  elif [[ -e /usr/share/zsh/vendor-completions/_awscli ]]; then
    _aws_zsh_completer_path=/usr/share/zsh/vendor-completions/_awscli
  # RPM
  else
    _aws_zsh_completer_path=/usr/share/zsh/site-functions/aws_zsh_completer.sh
  fi
fi

[[ -r $_aws_zsh_completer_path ]] && source $_aws_zsh_completer_path
unset _aws_zsh_completer_path _brew_prefix
