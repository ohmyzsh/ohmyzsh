function agp() {
  echo "${AWS_PROFILE:-}"
}

function agr() {
  echo "${AWS_REGION:-}"
}

# Update state file if enabled
function _aws_update_state() {
  if [[ "$AWS_PROFILE_STATE_ENABLED" == true ]]; then
    local state_dir="$(dirname "${AWS_STATE_FILE}")"
    if [[ ! -d "$state_dir" ]]; then
      mkdir -p "$state_dir" 2>/dev/null || return 1
    fi
    echo "${AWS_PROFILE:-} ${AWS_REGION:-}" > "${AWS_STATE_FILE}"
  fi
}

function _aws_clear_state() {
  if [[ "$AWS_PROFILE_STATE_ENABLED" == true ]]; then
    local state_dir="$(dirname "${AWS_STATE_FILE}")"
    if [[ ! -d "$state_dir" ]]; then
      mkdir -p "$state_dir" 2>/dev/null || return 1
    fi
    : > "${AWS_STATE_FILE}"
  fi
}

# AWS profile selection
function asp() {
  if [[ -z "$1" ]]; then
    unset AWS_DEFAULT_PROFILE AWS_PROFILE AWS_EB_PROFILE AWS_PROFILE_REGION
    _aws_clear_state
    echo "AWS profile cleared."
    return 0
  fi

  local -a available_profiles
  available_profiles=($(aws_profiles))
  if [[ -z "${available_profiles[(r)$1]}" ]]; then
    echo "Profile '$1' not found in '${AWS_CONFIG_FILE:-$HOME/.aws/config}'" >&2
    echo "Available profiles: ${(j:, :)available_profiles:-no profiles found}" >&2
    return 1
  fi

  export AWS_DEFAULT_PROFILE="$1"
  export AWS_PROFILE="$1"
  export AWS_EB_PROFILE="$1"

  AWS_PROFILE_REGION="$(aws configure get region)" || AWS_PROFILE_REGION=""
  export AWS_PROFILE_REGION

  _aws_update_state

  case "$2" in
    "login")
      if [[ -n "$3" ]]; then
        aws sso login --sso-session "$3"
      else
        aws sso login
      fi
      ;;
    "logout")
      aws sso logout
      ;;
  esac
}

# AWS region selection
function asr() {
  if [[ -z "$1" ]]; then
    unset AWS_DEFAULT_REGION AWS_REGION
    _aws_update_state
    echo "AWS region cleared."
    return 0
  fi

  local -a available_regions
  available_regions=($(aws_regions))
  if [[ -z "${available_regions[(r)$1]}" ]]; then
    echo "Invalid region. Available regions:" >&2
    aws_regions >&2
    return 1
  fi

  export AWS_DEFAULT_REGION="$1"
  export AWS_REGION="$1"
  _aws_update_state
}

# AWS profile switch
function acp() {
  if [[ -z "$1" ]]; then
    unset AWS_DEFAULT_PROFILE AWS_PROFILE AWS_EB_PROFILE AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
    echo "AWS profile cleared."
    return 0
  fi

  local -a available_profiles
  available_profiles=($(aws_profiles))
  if [[ -z "${available_profiles[(r)$1]}" ]]; then
    echo "Profile '$1' not found in '${AWS_CONFIG_FILE:-$HOME/.aws/config}'" >&2
    echo "Available profiles: ${(j:, :)available_profiles:-no profiles found}" >&2
    return 1
  fi

  local profile="$1"
  local mfa_token="$2"

  # Get fallback credentials
  local aws_access_key_id
  local aws_secret_access_key
  local aws_session_token
  
  aws_access_key_id="$(aws configure get aws_access_key_id --profile "$profile")"
  aws_secret_access_key="$(aws configure get aws_secret_access_key --profile "$profile")"
  aws_session_token="$(aws configure get aws_session_token --profile "$profile")"

  # Check for MFA configuration
  local mfa_serial
  local sess_duration
  
  mfa_serial="$(aws configure get mfa_serial --profile "$profile")"
  sess_duration="$(aws configure get duration_seconds --profile "$profile")"

  if [[ -n "$mfa_serial" ]]; then
    local -a mfa_opt
    if [[ -z "$mfa_token" ]]; then
      echo -n "Please enter your MFA token for $mfa_serial: "
      read -r mfa_token
    fi
    if [[ -z "$sess_duration" ]]; then
      echo -n "Please enter the session duration in seconds (900-43200; default: 3600): "
      read -r sess_duration
    fi
    mfa_opt=(--serial-number "$mfa_serial" --token-code "$mfa_token" --duration-seconds "${sess_duration:-3600}")
  fi

  # Check for role assumption
  local role_arn
  local sess_name
  
  role_arn="$(aws configure get role_arn --profile "$profile")"
  sess_name="$(aws configure get role_session_name --profile "$profile")"

  if [[ -n "$role_arn" ]]; then
    local -a aws_command
    aws_command=(aws sts assume-role --role-arn "$role_arn" "${mfa_opt[@]}")

    local external_id
    external_id="$(aws configure get external_id --profile "$profile")"
    if [[ -n "$external_id" ]]; then
      aws_command+=(--external-id "$external_id")
    fi

    local source_profile
    source_profile="$(aws configure get source_profile --profile "$profile")"
    if [[ -z "$sess_name" ]]; then
      sess_name="${source_profile:-$profile}"
    fi
    aws_command+=(--profile="${source_profile:-$profile}" --role-session-name "$sess_name")

    echo "Assuming role $role_arn using profile ${source_profile:-$profile}"
  else
    local -a aws_command
    aws_command=(aws sts get-session-token --profile="$profile" "${mfa_opt[@]}")
    echo "Obtaining session token for profile $profile"
  fi

  aws_command+=(--query '[Credentials.AccessKeyId,Credentials.SecretAccessKey,Credentials.SessionToken]' --output text)

  local credentials
  credentials="$(${aws_command[@]})" || return 1
  if [[ -n "$credentials" ]]; then
    read -r aws_access_key_id aws_secret_access_key aws_session_token <<< "$credentials"
  fi

  if [[ -n "$aws_access_key_id" && -n "$aws_secret_access_key" ]]; then
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
  else
    echo "Failed to obtain valid credentials" >&2
    return 1
  fi
}

function aws_change_access_key() {
  if [[ -z "$1" ]]; then
    echo "usage: ${0} <profile>" >&2
    return 1
  fi

  local profile="$1"
  local original_aws_access_key_id
  original_aws_access_key_id="$(aws configure get aws_access_key_id --profile "$profile")"

  if ! asp "$profile"; then
    return 1
  fi

  echo "Generating a new access key pair..."
  if aws --no-cli-pager iam create-access-key; then
    echo "Insert the newly generated credentials when asked."
    aws --no-cli-pager configure --profile "$profile"
  else
    echo "Current access keys:"
    aws --no-cli-pager iam list-access-keys
    echo "Profile \"${profile}\" is currently using the $original_aws_access_key_id key."
    echo "You can delete an old access key by running: aws --profile $profile iam delete-access-key --access-key-id AccessKeyId"
    return 1
  fi

  echo -n "Would you like to disable your previous access key (${original_aws_access_key_id}) now? [y/N] "
  read -r yn
  case "$yn" in
    [Yy]*)
      echo "Disabling access key ${original_aws_access_key_id}..."
      if aws --no-cli-pager iam update-access-key --access-key-id "${original_aws_access_key_id}" --status Inactive; then
        echo "Access key disabled successfully."
      else
        echo "Failed to disable ${original_aws_access_key_id} key." >&2
      fi
      ;;
  esac
  
  echo "You can now safely delete the old access key by running:"
  echo "aws --profile $profile iam delete-access-key --access-key-id ${original_aws_access_key_id}"
  echo "Your current keys are:"
  aws --no-cli-pager iam list-access-keys
}

function aws_regions() {
  local region="${AWS_DEFAULT_REGION:-${AWS_REGION:-us-west-1}}"

  if [[ -n "$AWS_DEFAULT_PROFILE" || -n "$AWS_PROFILE" ]]; then
    aws ec2 describe-regions --region "$region" --query 'Regions[].RegionName' --output text | tr '\t' '\n'
  else
    echo "You must specify an AWS profile." >&2
    return 1
  fi
}

function aws_profiles() {
  if aws --no-cli-pager configure list-profiles 2>/dev/null; then
    return 0
  fi
  
  local config_file="${AWS_CONFIG_FILE:-$HOME/.aws/config}"
  [[ -r "$config_file" ]] || return 1
  grep -Eo '\[.*\]' "$config_file" | sed -E 's/^[[:space:]]*\[(profile)?[[:space:]]*([^[:space:]]+)\][[:space:]]*$/\2/g'
}

# Completion functions
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
  local _aws_to_show=""
  local region="${AWS_REGION:-${AWS_DEFAULT_REGION:-$AWS_PROFILE_REGION}}"

  if [[ -n "$AWS_PROFILE" ]]; then
    _aws_to_show="${ZSH_THEME_AWS_PROFILE_PREFIX:-<aws:}${AWS_PROFILE}${ZSH_THEME_AWS_PROFILE_SUFFIX:->}"
  fi

  if [[ -n "$region" ]]; then
    [[ -n "$_aws_to_show" ]] && _aws_to_show+="${ZSH_THEME_AWS_DIVIDER:- }"
    _aws_to_show+="${ZSH_THEME_AWS_REGION_PREFIX:-<region:}${region}${ZSH_THEME_AWS_REGION_SUFFIX:->}"
  fi

  echo "$_aws_to_show"
}

# Add AWS prompt to RPROMPT if enabled
if [[ "$SHOW_AWS_PROMPT" != false && "$RPROMPT" != *'$(aws_prompt_info)'* ]]; then
  RPROMPT='$(aws_prompt_info)'"$RPROMPT"
fi

# Initialize state from file if enabled
if [[ "$AWS_PROFILE_STATE_ENABLED" == true ]]; then
  AWS_STATE_FILE="${AWS_STATE_FILE:-/tmp/.aws_current_profile}"
  if [[ -s "$AWS_STATE_FILE" ]]; then
    local -a aws_state
    aws_state=($(< "$AWS_STATE_FILE"))

    export AWS_DEFAULT_PROFILE="${aws_state[1]}"
    export AWS_PROFILE="$AWS_DEFAULT_PROFILE"
    export AWS_EB_PROFILE="$AWS_DEFAULT_PROFILE"

    if [[ -z "${aws_state[2]}" ]]; then
      AWS_REGION="$(aws configure get region)"
    else
      AWS_REGION="${aws_state[2]}"
    fi

    export AWS_REGION
    export AWS_DEFAULT_REGION="$AWS_REGION"
  fi
fi

# Load AWS CLI completions
if command -v aws_completer &>/dev/null; then
  autoload -Uz bashcompinit && bashcompinit
  complete -C aws_completer aws
else
  function _awscli-homebrew-installed() {
    (( $+commands[brew] )) || return 1

    if [[ -h /usr/local/opt/awscli ]]; then
      _brew_prefix=/usr/local/opt/awscli
    else
      _brew_prefix="$(brew --prefix awscli)"
    fi
  }

  local _aws_zsh_completer_path="$commands[aws_zsh_completer.sh]"

  if [[ -z "$_aws_zsh_completer_path" ]]; then
    if _awscli-homebrew-installed; then
      _aws_zsh_completer_path="$_brew_prefix/libexec/bin/aws_zsh_completer.sh"
    elif [[ -e /usr/share/zsh/vendor-completions/_awscli ]]; then
      _aws_zsh_completer_path=/usr/share/zsh/vendor-completions/_awscli
    elif [[ -e "${commands[aws]:P:h:h}/share/zsh/site-functions/aws_zsh_completer.sh" ]]; then
      _aws_zsh_completer_path="${commands[aws]:P:h:h}/share/zsh/site-functions/aws_zsh_completer.sh"
    else
      _aws_zsh_completer_path=/usr/share/zsh/site-functions/aws_zsh_completer.sh
    fi
  fi

  [[ -r "$_aws_zsh_completer_path" ]] && source "$_aws_zsh_completer_path"
  unset _aws_zsh_completer_path _brew_prefix
fi
