# Terminal.app session restoration from /etc/bashrc_Apple_Terminal for ZSH

if [[ ${SHELL_SESSION_DID_INIT:-0} -eq 0 ]] && [[ -n "${TERM_SESSION_ID}" ]] then
  SHELL_SESSION_DID_INIT=1

  #
  # Set up the session directory/file.
  #

  SHELL_SESSION_DIR="${HOME}/.zsh_sessions"
  SHELL_SESSION_FILE="${SHELL_SESSION_DIR}/${TERM_SESSION_ID}.session"
  mkdir -p "${SHELL_SESSION_DIR}"

  #
  # Restore previous session state.
  #

  if [[ -r "${SHELL_SESSION_FILE}" ]]; then
    . "${SHELL_SESSION_FILE}"
    rm "${SHELL_SESSION_FILE}"
  fi

  #
  # Arrange to save session state when exiting the shell.
  #

  function shell_session_save() {
    if [[ -n "${SHELL_SESSION_FILE}" ]]; then
      echo -n 'Saving session...'
      typeset -f shell_session_save_user_state >/dev/null && shell_session_save_user_state
      echo 'completed.'
    fi
  }

  #
  # Delete old session files. (Not more than once a day.)
  #

  SHELL_SESSION_TIMESTAMP_FILE="${SHELL_SESSION_DIR}/_expiration_check_timestamp"

  function shell_session_delete_expired() {
    if [[ ! -e "${SHELL_SESSION_TIMESTAMP_FILE}" || -z $(find "${SHELL_SESSION_TIMESTAMP_FILE}" -mtime -1d) ]]; then
      local expiration_lock_file="${SHELL_SESSION_DIR}/_expiration_lockfile"

      if shlock -f "${expiration_lock_file}" -p $$; then
        echo -n 'Deleting expired sessions...'
        local delete_count=$(find "${SHELL_SESSION_DIR}" -type f -mtime +2w -print -delete | wc -l)
        [ "${delete_count}" -gt 0 ] && echo ${delete_count}' completed.' || echo 'none found.'
        touch "${SHELL_SESSION_TIMESTAMP_FILE}"
        rm "${expiration_lock_file}"
      fi
    fi
  }

  #
  # Update saved session state when exiting.
  #

  function shell_session_update() {
    shell_session_save && shell_session_delete_expired
  }

  trap shell_session_update EXIT
fi
