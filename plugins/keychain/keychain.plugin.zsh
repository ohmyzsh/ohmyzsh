(( $+commands[keychain] )) || return

# Define SHORT_HOST if not defined (%m = host name up to first .)
SHORT_HOST=${SHORT_HOST:-${(%):-%m}}

function {
  local -a identities
  local -a options
  local _keychain_env_sh
  local _keychain_env_sh_gpg
  local version_string major

  # load identities to manage.
  zstyle -a :omz:plugins:keychain identities identities

  # load additional options
  zstyle -a :omz:plugins:keychain options options

  # Detect major version robustly: case-insensitive, tolerant of
  # "keychain 3.0.0_beta3" / "Keychain 3.0.0" / etc.
  version_string=$(keychain --version 2>&1)
  if [[ "${version_string:l}" =~ '([0-9]+)\.[0-9]+' ]]; then
    major=${match[1]}
  else
    major=2
  fi

  if (( major >= 3 )); then
    # Keychain 3.x: subcommand-based CLI, no --agents.
    keychain add ${^options:-} --host $SHORT_HOST ${^identities}
  else
    local agents

    # load agents to start (only used by keychain < 2.9).
    zstyle -s :omz:plugins:keychain agents agents

    autoload -Uz is-at-least
    if [[ "${version_string:l}" =~ 'keychain ([0-9]+\.[0-9]+)' ]] && \
       is-at-least 2.9 "$match[1]"; then
      keychain ${^options:-} ${^identities} --host $SHORT_HOST
    else
      keychain ${^options:-} --agents ${agents:-gpg} ${^identities} --host $SHORT_HOST
    fi
  fi

  # Get the filenames to store/lookup the environment from
  _keychain_env_sh="$HOME/.keychain/$SHORT_HOST-sh"
  _keychain_env_sh_gpg="$HOME/.keychain/$SHORT_HOST-sh-gpg"

  # Source environment settings.
  [ -f "$_keychain_env_sh" ]     && . "$_keychain_env_sh"
  [ -f "$_keychain_env_sh_gpg" ] && . "$_keychain_env_sh_gpg"
}
