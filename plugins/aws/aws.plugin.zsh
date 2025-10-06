function agp() {
  echo $AWS_PROFILE
}

function agr() {
  echo $AWS_REGION
}

# Update state file if enabled
function _aws_update_state() {
  if [[ "$AWS_PROFILE_STATE_ENABLED" == true ]]; then
    test -d $(dirname ${AWS_STATE_FILE}) || exit 1
    echo "${AWS_PROFILE} ${AWS_REGION}" > "${AWS_STATE_FILE}"
  fi
}

function _aws_clear_state() {
  if [[ "$AWS_PROFILE_STATE_ENABLED" == true ]]; then
    test -d $(dirname ${AWS_STATE_FILE}) || exit 1
    echo -n > "${AWS_STATE_FILE}"
  fi
}

# AWS profile selection
function asp() {
  if [[ -z "$1" ]]; then
    unset AWS_DEFAULT_PROFILE AWS_PROFILE AWS_EB_PROFILE AWS_PROFILE_REGION
    _aws_clear_state
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

  export AWS_PROFILE_REGION=$(aws configure get region)

  _aws_update_state

  if [[ "$2" == "login" ]]; then
    if [[ -n "$3" ]]; then
      aws sso login --sso-session $3
    else
      aws sso login
    fi
  elif [[ "$2" == "logout" ]]; then
    aws sso logout
  fi
}

# AWS region selection
function asr() {
  if [[ -z "$1" ]]; then
    unset AWS_DEFAULT_REGION AWS_REGION
    _aws_update_state
    echo AWS region cleared.
    return
  fi

  local -a available_regions
  available_regions=($(aws_regions))
  if [[ -z "${available_regions[(r)$1]}" ]]; then
    echo "${fg[red]}Available regions: \n$(aws_regions)"
    return 1
  fi

  export AWS_REGION=$1
  export AWS_DEFAULT_REGION=$1
  _aws_update_state
}

# AWS profile switch
function acp() {
  if [[ -z "$1" ]]; then
    unset AWS_DEFAULT_PROFILE AWS_PROFILE AWS_EB_PROFILE
    unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
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

  local profile="$1"
  local mfa_token="$2"

  # Get fallback credentials for if the aws command fails or no command is run
  local aws_access_key_id="$(aws configure get aws_access_key_id --profile $profile)"
  local aws_secret_access_key="$(aws configure get aws_secret_access_key --profile $profile)"
  local aws_session_token="$(aws configure get aws_session_token --profile $profile)"


  # First, if the profile has MFA configured, lets get the token and session duration
  local mfa_serial="$(aws configure get mfa_serial --profile $profile)"
  local sess_duration="$(aws configure get duration_seconds --profile $profile)"

  if [[ -n "$mfa_serial" ]]; then
    local -a mfa_opt
    if [[ -z "$mfa_token" ]]; then
      echo -n "Please enter your MFA token for $mfa_serial: "
      read -r mfa_token
    fi
    if [[ -z "$sess_duration" ]]; then
      echo -n "Please enter the session duration in seconds (900-43200; default: 3600, which is the default maximum for a role): "
      read -r sess_duration
    fi
    mfa_opt=(--serial-number "$mfa_serial" --token-code "$mfa_token" --duration-seconds "${sess_duration:-3600}")
  fi

  # Now see whether we need to just MFA for the current role, or assume a different one
  local role_arn="$(aws configure get role_arn --profile $profile)"
  local sess_name="$(aws configure get role_session_name --profile $profile)"

  if [[ -n "$role_arn" ]]; then
    # Means we need to assume a specified role
    aws_command=(aws sts assume-role --role-arn "$role_arn" "${mfa_opt[@]}")

    # Check whether external_id is configured to use while assuming the role
    local external_id="$(aws configure get external_id --profile $profile)"
    if [[ -n "$external_id" ]]; then
      aws_command+=(--external-id "$external_id")
    fi

    # Get source profile to use to assume role
    local source_profile="$(aws configure get source_profile --profile $profile)"
    if [[ -z "$sess_name" ]]; then
      sess_name="${source_profile:-profile}"
    fi
    aws_command+=(--profile="${source_profile:-profile}" --role-session-name "${sess_name}")

    echo "Assuming role $role_arn using profile ${source_profile:-profile}"
  else
    # Means we only need to do MFA
    aws_command=(aws sts get-session-token --profile="$profile" "${mfa_opt[@]}")
    echo "Obtaining session token for profile $profile"
  fi

  # Format output of aws command for easier processing
  aws_command+=(--query '[Credentials.AccessKeyId,Credentials.SecretAccessKey,Credentials.SessionToken]' --output text)

  # Run the aws command to obtain credentials
  local -a credentials
  credentials=(${(ps:\t:)"$(${aws_command[@]})"})

  if [[ -n "$credentials" ]]; then
    aws_access_key_id="${credentials[1]}"
    aws_secret_access_key="${credentials[2]}"
    aws_session_token="${credentials[3]}"
  fi

  # Switch to AWS profile
  if [[ -n "${aws_access_key_id}" && -n "$aws_secret_access_key" ]]; then
    export AWS_DEFAULT_PROFILE="$profile"
    export AWS_PROFILE="$profile"
    export AWS_EB_PROFILE="$profile"
    export AWS_ACCESS_KEY_ID="$aws_access_key_id"
    export AWS_SECRET_ACCESS_KEY="$aws_secret_access_key"

    if [[ -n "$aws_session_token" ]]; then
      export AWS_SESSION_TOKEN="$aws_session_token"
    else
      unset AWS_SESSION_TOKEN
    fi

    echo "Switched to AWS Profile: $profile"
  fi
}

function aws_change_access_key() {
  if [[ -z "$1" ]]; then
    echo "usage: $0 <profile>"
    return 1
  fi

  local profile="$1"
  # Get current access key
  local original_aws_access_key_id="$(aws configure get aws_access_key_id --profile $profile)"

  asp "$profile" || return 1
  echo "Generating a new access key pair for you now."
  if aws --no-cli-pager iam create-access-key; then
    echo "Insert the newly generated credentials when asked."
    aws --no-cli-pager configure --profile $profile
  else
    echo "Current access keys:"
    aws --no-cli-pager iam list-access-keys
    echo "Profile \"${profile}\" is currently using the $original_aws_access_key_id key. You can delete an old access key by running \`aws --profile $profile iam delete-access-key --access-key-id AccessKeyId\`"
    return 1
  fi

  read -q "yn?Would you like to disable your previous access key (${original_aws_access_key_id}) now? "
  case $yn in
    [Yy]*)
      echo -n "\nDisabling access key ${original_aws_access_key_id}..."
      if aws --no-cli-pager iam update-access-key --access-key-id ${original_aws_access_key_id} --status Inactive; then
        echo "done."
      else
        echo "\nFailed to disable ${original_aws_access_key_id} key."
      fi
      ;;
    *)
      echo ""
      ;;
  esac
  echo "You can now safely delete the old access key by running \`aws --profile $profile iam delete-access-key --access-key-id ${original_aws_access_key_id}\`"
  echo "Your current keys are:"
  aws --no-cli-pager iam list-access-keys
}

function aws_regions() {
  local region
  if [[ $AWS_DEFAULT_REGION ]];then
      region="$AWS_DEFAULT_REGION"
  elif [[ $AWS_REGION ]];then
      region="$AWS_REGION"
  else
      region="us-west-1"
  fi

  if [[ $AWS_DEFAULT_PROFILE || $AWS_PROFILE ]];then
    aws ec2 describe-regions --region $region |grep RegionName | awk -F ':' '{gsub(/"/, "", $2);gsub(/,/, "", $2);gsub(/ /, "", $2);  print $2}'
  else
    echo "You must specify a AWS profile."
  fi
}

function aws_profiles() {
  aws --no-cli-pager configure list-profiles 2> /dev/null && return
  [[ -r "${AWS_CONFIG_FILE:-$HOME/.aws/config}" ]] || return 1
  grep --color=never -Eo '\[.*\]' "${AWS_CONFIG_FILE:-$HOME/.aws/config}" | sed -E 's/^[[:space:]]*\[(profile)?[[:space:]]*([^[:space:]]+)\][[:space:]]*$/\2/g'
}

function _aws_regions() {
  reply=($(aws_regions))
}
compctl -K _aws_regions asr

function _aws_profiles() {
  reply=($(aws_profiles))
}
compctl -K _aws_profiles asp acp aws_change_access_key

# AWS prompt
function aws_prompt_info() {
  local _aws_to_show
  local region="${AWS_REGION:-${AWS_DEFAULT_REGION:-$AWS_PROFILE_REGION}}"

  if [[ -n "$AWS_PROFILE" ]];then
    _aws_to_show+="${ZSH_THEME_AWS_PROFILE_PREFIX="<aws:"}${AWS_PROFILE}${ZSH_THEME_AWS_PROFILE_SUFFIX=">"}"
  fi

  if [[ -n "$region" ]]; then
    [[ -n "$_aws_to_show" ]] && _aws_to_show+="${ZSH_THEME_AWS_DIVIDER=" "}"
    _aws_to_show+="${ZSH_THEME_AWS_REGION_PREFIX="<region:"}${region}${ZSH_THEME_AWS_REGION_SUFFIX=">"}"
  fi

  echo "$_aws_to_show"
}

if [[ "$SHOW_AWS_PROMPT" != false && "$RPROMPT" != *'$(aws_prompt_info)'* ]]; then
  RPROMPT='$(aws_prompt_info)'"$RPROMPT"
fi

if [[ "$AWS_PROFILE_STATE_ENABLED" == true ]]; then
  AWS_STATE_FILE="${AWS_STATE_FILE:-/tmp/.aws_current_profile}"
  test -s "${AWS_STATE_FILE}" || return

  aws_state=($(cat $AWS_STATE_FILE))

  export AWS_DEFAULT_PROFILE="${aws_state[1]}"
  export AWS_PROFILE="$AWS_DEFAULT_PROFILE"
  export AWS_EB_PROFILE="$AWS_DEFAULT_PROFILE"

  test -z "${aws_state[2]}" && AWS_REGION=$(aws configure get region)

  export AWS_REGION=${AWS_REGION:-$aws_state[2]}
  export AWS_DEFAULT_REGION="$AWS_REGION"
fi

# Load awscli completions

# AWS CLI v2 comes with its own autocompletion. Check if that is there, otherwise fall back
if command -v aws_completer &> /dev/null; then
  autoload -Uz bashcompinit && bashcompinit
  complete -C aws_completer aws
else
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
    # NixOS
    elif [[ -e "${commands[aws]:P:h:h}/share/zsh/site-functions/aws_zsh_completer.sh" ]]; then
      _aws_zsh_completer_path="${commands[aws]:P:h:h}/share/zsh/site-functions/aws_zsh_completer.sh"
    # RPM
    else
      _aws_zsh_completer_path=/usr/share/zsh/site-functions/aws_zsh_completer.sh
    fi
  fi

  [[ -r $_aws_zsh_completer_path ]] && source $_aws_zsh_completer_path
  unset _aws_zsh_completer_path _brew_prefix
fi

