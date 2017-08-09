#####################################################
# iTerm2 plugin for oh-my-zsh                       #
# Author: Aviv Rosenberg (github.com/avivrosenberg) #
#####################################################

###
# This plugin is only relevant if the terminal is iTerm2 on OSX.
if [[ "$OSTYPE" == darwin* ]] && [[ -n "$ITERM_SESSION_ID" ]] ; then

  ###
  # Executes an arbitrary iTerm2 command via an escape code sequce.
  # See https://iterm2.com/documentation-escape-codes.html for all supported commands.
  # Example: $ _iterm2_command "1337;StealFocus"
  function _iterm2_command() {
    local cmd="$1"

    # Escape codes for wrapping commands for iTerm2.
    local iterm2_prefix="\x1B]"
    local iterm2_suffix="\x07"

    # If we're in tmux, a special escape code must be prepended/appended so that
    # the iTerm2 escape code is passed on into iTerm2.
    if [[ -n $TMUX ]]; then
      local tmux_prefix="\x1BPtmux;\x1B"
      local tmux_suffix="\x1B\\"
    fi

    echo -n "${tmux_prefix}${iterm2_prefix}${cmd}${iterm2_suffix}${tmux_suffix}"
  }

  ###
  # iterm2_profile(): Function for changing the current terminal window's
  # profile (colors, fonts, settings, etc).
  # To change the current iTerm2 profile, call this function and pass in a name
  # of another existing iTerm2 profile (name can contain spaces).
  function iterm2_profile() {
    # Desired name of profile
    local profile="$1"

    # iTerm2 command for changing profile
    local cmd="1337;SetProfile=$profile"

    # send the sequence
    _iterm2_command "${cmd}"

    # update shell variable
    ITERM_PROFILE="$profile"
  }

fi
