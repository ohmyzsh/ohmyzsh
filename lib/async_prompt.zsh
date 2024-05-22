# The async code is taken from
# https://github.com/zsh-users/zsh-autosuggestions/blob/master/src/async.zsh
# https://github.com/woefe/git-prompt.zsh/blob/master/git-prompt.zsh

zmodload zsh/system
autoload -Uz is-at-least

# For now, async prompt function handlers are set up like so:
# First, define the async function handler and register the handler
# with _omz_register_handler:
#
#  function _git_prompt_status_async {
#    # Do some expensive operation that outputs to stdout
#  }
#  _omz_register_handler _git_prompt_status_async
#
# Then add a stub prompt function in `$PROMPT` or similar prompt variables,
# which will show the output of "$_OMZ_ASYNC_OUTPUT[handler_name]":
#
#  function git_prompt_status {
#    echo -n $_OMZ_ASYNC_OUTPUT[_git_prompt_status_async]
#  }
#
#  RPROMPT='$(git_prompt_status)'
#
# This API is subject to change and optimization. Rely on it at your own risk.

function _omz_register_handler {
  setopt localoptions noksharrays
  typeset -ga _omz_async_functions
  # we want to do nothing if there's no $1 function or we already set it up
  if [[ -z "$1" ]] || (( ! ${+functions[$1]} )) \
    || (( ${_omz_async_functions[(Ie)$1]} )); then
    return
  fi
  _omz_async_functions+=("$1")
  # let's add the hook to async_request if it's not there yet
  if (( ! ${precmd_functions[(Ie)_omz_async_request]} )) \
    && (( ${+functions[_omz_async_request]})); then
    autoload -Uz add-zsh-hook
    add-zsh-hook precmd _omz_async_request
  fi
}

# Set up async handlers and callbacks
function _omz_async_request {
  local -i ret=$?
  typeset -gA _OMZ_ASYNC_FDS _OMZ_ASYNC_PIDS _OMZ_ASYNC_OUTPUT

  # executor runs a subshell for all async requests based on key
  local handler
  for handler in ${_omz_async_functions}; do
    (( ${+functions[$handler]} )) || continue

    local fd=${_OMZ_ASYNC_FDS[$handler]:--1}
    local pid=${_OMZ_ASYNC_PIDS[$handler]:--1}

    # If we've got a pending request, cancel it
    if (( fd != -1 && pid != -1 )) && { true <&$fd } 2>/dev/null; then
      # Close the file descriptor and remove the handler
      exec {fd}<&-
      zle -F $fd

      # Zsh will make a new process group for the child process only if job
      # control is enabled (MONITOR option)
      if [[ -o MONITOR ]]; then
        # Send the signal to the process group to kill any processes that may
        # have been forked by the async function handler
        kill -TERM -$pid 2>/dev/null
      else
        # Kill just the child process since it wasn't placed in a new process
        # group. If the async function handler forked any child processes they may
        # be orphaned and left behind.
        kill -TERM $pid 2>/dev/null
      fi
    fi

    # Define global variables to store the file descriptor, PID and output
    _OMZ_ASYNC_FDS[$handler]=-1
    _OMZ_ASYNC_PIDS[$handler]=-1

    # Fork a process to fetch the git status and open a pipe to read from it
    exec {fd}< <(
      # Tell parent process our PID
      builtin echo ${sysparams[pid]}
      # Set exit code for the handler if used
      () { return $ret }
      # Run the async function handler
      $handler
    )

    # Save FD for handler
    _OMZ_ASYNC_FDS[$handler]=$fd

    # There's a weird bug here where ^C stops working unless we force a fork
    # See https://github.com/zsh-users/zsh-autosuggestions/issues/364
    # and https://github.com/zsh-users/zsh-autosuggestions/pull/612
    is-at-least 5.8 || command true

    # Save the PID from the handler child process
    read -u $fd "_OMZ_ASYNC_PIDS[$handler]"

    # When the fd is readable, call the response handler
    zle -F "$fd" _omz_async_callback
  done
}

# Called when new data is ready to be read from the pipe
function _omz_async_callback() {
  emulate -L zsh

  local fd=$1   # First arg will be fd ready for reading
  local err=$2  # Second arg will be passed in case of error

  if [[ -z "$err" || "$err" == "hup" ]]; then
    # Get handler name from fd
    local handler="${(k)_OMZ_ASYNC_FDS[(r)$fd]}"

    # Store old output which is supposed to be already printed
    local old_output="${_OMZ_ASYNC_OUTPUT[$handler]}"

    # Read output from fd
    IFS= read -r -u $fd -d '' "_OMZ_ASYNC_OUTPUT[$handler]"

    # Repaint prompt if output has changed
    if [[ "$old_output" != "${_OMZ_ASYNC_OUTPUT[$handler]}" ]]; then
      zle .reset-prompt
      zle -R
    fi

    # Close the fd
    exec {fd}<&-
  fi

  # Always remove the handler
  zle -F "$fd"

  # Unset global FD variable to prevent closing user created FDs in the precmd hook
  _OMZ_ASYNC_FDS[$handler]=-1
  _OMZ_ASYNC_PIDS[$handler]=-1
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _omz_async_request
