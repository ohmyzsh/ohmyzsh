#####################################################
# iTerm2 plugin for oh-my-zsh                       #
# Author: Aviv Rosenberg (github.com/avivrosenberg) #
#####################################################

###
# This plugin is only relevant if the terminal is iTerm2 on OSX.
if [[ "$OSTYPE" == darwin* ]] && [[ -n "$ITERM_SESSION_ID" ]] ; then

  ###
  # iterm2_profile(): Function for changing the current terminal window's
  # profile (colors, fonts, settings, etc).
  # To change the current iTerm2 profile, call this function and pass in a name
  # of another existing iTerm2 profile (name can contain spaces).
  function iterm2_profile() {
    # Desired name of profile
    local profile="$1"

    # iTerm2 escape code for changing profile
    local iterm2_code="\x1b]50;SetProfile=$profile\x7"

    # If we're in tmux, a special escape code must be prepended
    # so that the iTerm2 escape code is passed on into iTerm2.
    local prefix=''
    local suffix=''
    if [[ -n $TMUX ]]; then
      prefix='\033Ptmux;\033'
      suffix='\033\\'
    fi

    # send the sequence
    echo -n "${prefix}${iterm2_code}${suffix}"

    # update shell variable
    ITERM_PROFILE="$profile"
  }

fi
