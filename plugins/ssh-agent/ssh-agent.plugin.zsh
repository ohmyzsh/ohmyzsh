<<<<<<< HEAD
#
# INSTRUCTIONS
#
#   To enable agent forwarding support add the following to
#   your .zshrc file:
#
#     zstyle :omz:plugins:ssh-agent agent-forwarding on
#
#   To load multiple identities use the identities style, For
#   example:
#
#     zstyle :omz:plugins:ssh-agent identities id_rsa id_rsa2 id_github
#
#   To set the maximum lifetime of the identities, use the
#   lifetime style. The lifetime may be specified in seconds
#   or as described in sshd_config(5) (see TIME FORMATS)
#   If left unspecified, the default lifetime is forever.
#
#     zstyle :omz:plugins:ssh-agent lifetime 4h
#
# CREDITS
#
#   Based on code from Joseph M. Reagle
#   http://www.cygwin.com/ml/cygwin/2001-06/msg00537.html
#
#   Agent forwarding support based on ideas from
#   Florent Thoumie and Jonas Pfenniger
#

local _plugin__ssh_env
local _plugin__forwarding

function _plugin__start_agent()
{
  local -a identities
=======
# Get the filename to store/lookup the environment from
ssh_env_cache="$HOME/.ssh/environment-$SHORT_HOST"

function _start_agent() {
  # Check if ssh-agent is already running
  if [[ -f "$ssh_env_cache" ]]; then
    . "$ssh_env_cache" > /dev/null

    # Test if $SSH_AUTH_SOCK is visible
    zmodload zsh/net/socket
    if [[ -S "$SSH_AUTH_SOCK" ]] && zsocket "$SSH_AUTH_SOCK" 2>/dev/null; then
      return 0
    fi
  fi

  # Set a maximum lifetime for identities added to ssh-agent
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
  local lifetime
  zstyle -s :omz:plugins:ssh-agent lifetime lifetime

  # start ssh-agent and setup environment
<<<<<<< HEAD
  /usr/bin/env ssh-agent ${lifetime:+-t} ${lifetime} | sed 's/^echo/#echo/' > ${_plugin__ssh_env}
  chmod 600 ${_plugin__ssh_env}
  . ${_plugin__ssh_env} > /dev/null

  # load identies
  zstyle -a :omz:plugins:ssh-agent identities identities
  echo starting ssh-agent...

  /usr/bin/ssh-add $HOME/.ssh/${^identities}
}

# Get the filename to store/lookup the environment from
if (( $+commands[scutil] )); then
  # It's OS X!
  _plugin__ssh_env="$HOME/.ssh/environment-$(scutil --get ComputerName)"
else
  _plugin__ssh_env="$HOME/.ssh/environment-$HOST"
fi

# test if agent-forwarding is enabled
zstyle -b :omz:plugins:ssh-agent agent-forwarding _plugin__forwarding
if [[ ${_plugin__forwarding} == "yes" && -n "$SSH_AUTH_SOCK" ]]; then
  # Add a nifty symlink for screen/tmux if agent forwarding
  [[ -L $SSH_AUTH_SOCK ]] || ln -sf "$SSH_AUTH_SOCK" /tmp/ssh-agent-$USER-screen

elif [ -f "${_plugin__ssh_env}" ]; then
  # Source SSH settings, if applicable
  . ${_plugin__ssh_env} > /dev/null
  ps x | grep ${SSH_AGENT_PID} | grep ssh-agent > /dev/null || {
    _plugin__start_agent;
  }
else
  _plugin__start_agent;
fi

# tidy up after ourselves
unfunction _plugin__start_agent
unset _plugin__forwarding
unset _plugin__ssh_env

=======
  zstyle -t :omz:plugins:ssh-agent quiet || echo >&2 "Starting ssh-agent ..."
  ssh-agent -s ${lifetime:+-t} ${lifetime} | sed '/^echo/d' >! "$ssh_env_cache"
  chmod 600 "$ssh_env_cache"
  . "$ssh_env_cache" > /dev/null
}

function _add_identities() {
  local id file line sig lines
  local -a identities loaded_sigs loaded_ids not_loaded
  zstyle -a :omz:plugins:ssh-agent identities identities

  # check for .ssh folder presence
  if [[ ! -d "$HOME/.ssh" ]]; then
    return
  fi

  # add default keys if no identities were set up via zstyle
  # this is to mimic the call to ssh-add with no identities
  if [[ ${#identities} -eq 0 ]]; then
    # key list found on `ssh-add` man page's DESCRIPTION section
    for id in id_rsa id_dsa id_ecdsa id_ed25519 identity; do
      # check if file exists
      [[ -f "$HOME/.ssh/$id" ]] && identities+=($id)
    done
  fi

  # get list of loaded identities' signatures and filenames
  if lines=$(ssh-add -l); then
    for line in ${(f)lines}; do
      loaded_sigs+=${${(z)line}[2]}
      loaded_ids+=${${(z)line}[3]}
    done
  fi

  # add identities if not already loaded
  for id in $identities; do
    # if id is an absolute path, make file equal to id
    [[ "$id" = /* ]] && file="$id" || file="$HOME/.ssh/$id"
    # check for filename match, otherwise try for signature match
    if [[ ${loaded_ids[(I)$file]} -le 0 ]]; then
      sig="$(ssh-keygen -lf "$file" | awk '{print $2}')"
      [[ ${loaded_sigs[(I)$sig]} -le 0 ]] && not_loaded+=("$file")
    fi
  done

  # abort if no identities need to be loaded
  if [[ ${#not_loaded} -eq 0 ]]; then
    return
  fi

  # pass extra arguments to ssh-add
  local args
  zstyle -a :omz:plugins:ssh-agent ssh-add-args args

  # use user specified helper to ask for password (ksshaskpass, etc)
  local helper
  zstyle -s :omz:plugins:ssh-agent helper helper

  if [[ -n "$helper" ]]; then
    if [[ -z "${commands[$helper]}" ]]; then
      echo >&2 "ssh-agent: the helper '$helper' has not been found."
    else
      SSH_ASKPASS="$helper" ssh-add "${args[@]}" ${^not_loaded} < /dev/null
      return $?
    fi
  fi

  ssh-add "${args[@]}" ${^not_loaded}
}

# Add a nifty symlink for screen/tmux if agent forwarding is enabled
if zstyle -t :omz:plugins:ssh-agent agent-forwarding \
   && [[ -n "$SSH_AUTH_SOCK" && ! -L "$SSH_AUTH_SOCK" ]]; then
  ln -sf "$SSH_AUTH_SOCK" /tmp/ssh-agent-$USERNAME-screen
else
  _start_agent
fi

# Don't add identities if lazy-loading is enabled
if ! zstyle -t :omz:plugins:ssh-agent lazy; then
  _add_identities
fi

unset agent_forwarding ssh_env_cache
unfunction _start_agent _add_identities
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
