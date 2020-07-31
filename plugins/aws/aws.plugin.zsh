function agp() {
  echo $AWS_PROFILE
}

# AWS profile selection
function asp() {
  if [[ -z "$1" ]]; then
    unset AWS_DEFAULT_PROFILE AWS_PROFILE AWS_EB_PROFILE AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
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

  local exists="$(aws configure get aws_access_key_id --profile $1)"
  local role_arn="$(aws configure get role_arn --profile $1)"
  local aws_access_key_id=""
  local aws_secret_access_key=""
  local aws_session_token=""
  if [[ -n $exists || -n $role_arn ]]; then
    if [[ -n $role_arn ]]; then
      local mfa_serial="$(aws configure get mfa_serial --profile $1)"
      local mfa_token=""
      local mfa_opt=""
      if [[ -n $mfa_serial ]]; then
        echo "Please enter your MFA token for $mfa_serial:"
        read mfa_token
        echo "Please enter the session duration in seconds (900-43200; default: 3600, which is the default maximum for a role):"
        read sess_duration
        if [[ -z $sess_duration ]]; then
          sess_duration = 3600
        fi
        mfa_opt="--serial-number $mfa_serial --token-code $mfa_token --duration-seconds $sess_duration"
      fi

      local ext_id="$(aws configure get external_id --profile $1)"
      local extid_opt=""
      if [[ -n $ext_id ]]; then
        extid_opt="--external-id $ext_id"
      fi

      local profile=$1
      local source_profile="$(aws configure get source_profile --profile $1)"
      if [[ -n $source_profile ]]; then
        profile=$source_profile
      fi

      echo "Assuming role $role_arn using profile $profile"
      local assume_cmd=(aws sts assume-role "--profile=$profile" "--role-arn $role_arn" "--role-session-name "$profile"" "$mfa_opt" "$extid_opt")
      local JSON="$(eval ${assume_cmd[@]})"

      aws_access_key_id="$(echo $JSON | jq -r '.Credentials.AccessKeyId')"
      aws_secret_access_key="$(echo $JSON | jq -r '.Credentials.SecretAccessKey')"
      aws_session_token="$(echo $JSON | jq -r '.Credentials.SessionToken')"
    else
      aws_access_key_id="$(aws configure get aws_access_key_id --profile $1)"
      aws_secret_access_key="$(aws configure get aws_secret_access_key --profile $1)"
      aws_session_token=""
    fi

    export AWS_DEFAULT_PROFILE=$1
    export AWS_PROFILE=$1
    export AWS_EB_PROFILE=$1
    export AWS_ACCESS_KEY_ID=$aws_access_key_id
    export AWS_SECRET_ACCESS_KEY=$aws_secret_access_key
    [[ -z "$aws_session_token" ]] && unset AWS_SESSION_TOKEN || export AWS_SESSION_TOKEN=$aws_session_token

    echo "Switched to AWS Profile: $1";
  fi
}

function aws_change_access_key() {
  if [[ -z "$1" ]]; then
    echo "usage: $0 <profile>"
    return 1
  fi

  echo Insert the credentials when asked.
  asp "$1" || return 1
  AWS_PAGER="" aws iam create-access-key
  AWS_PAGER="" aws configure --profile "$1"

  echo You can now safely delete the old access key running \`aws iam delete-access-key --access-key-id ID\`
  echo Your current keys are:
  AWS_PAGER="" aws iam list-access-keys
}

function aws_profiles() {
  [[ -r "${AWS_CONFIG_FILE:-$HOME/.aws/config}" ]] || return 1
  grep --color=never -Eo '\[.*\]' "${AWS_CONFIG_FILE:-$HOME/.aws/config}" | sed -E 's/^[[:space:]]*\[(profile)?[[:space:]]*([-_[:alnum:]\.@]+)\][[:space:]]*$/\2/g'
}

function _aws_profiles() {
  reply=($(aws_profiles))
}
compctl -K _aws_profiles asp aws_change_access_key

# AWS prompt
function aws_prompt_info() {
  [[ -z $AWS_PROFILE ]] && return
  echo "${ZSH_THEME_AWS_PREFIX:=<aws:}${AWS_PROFILE}${ZSH_THEME_AWS_SUFFIX:=>}"
}

if [ "$SHOW_AWS_PROMPT" != false ]; then
  RPROMPT='$(aws_prompt_info)'"$RPROMPT"
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
