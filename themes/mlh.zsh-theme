# The Official Theme of Major League Hacking

##     ## ##       ##     ##
###   ### ##       ##     ##
#### #### ##       ##     ##
## ### ## ##       #########
##     ## ##       ##     ##
##     ## ##       ##     ##
##     ## ######## ##     ##

# # # # # # # # # # # # # # # # # #
# # # Feel free to customize! # # #
# # # # # # # # # # # # # # # # # #

# To easily discover colors and their codes, type `spectrum_ls` in the terminal

# enable or disable particular elements
PRINT_EXIT_CODE=true
PRINT_TIME=true

# symbols
AT_SYMBOL=" @ "
IN_SYMBOL=" in "
ON_SYMBOL=" on "
SHELL_SYMBOL="$"

# colors
USER_COLOR="%F{001}"
DEVICE_COLOR="%F{033}"
DIR_COLOR="%F{220}"
BRANCH_COLOR="%F{001}"
TIME_COLOR="%F{033}"

username() {
  echo "$USER_COLOR%n%f"
}

# Prints device name
device() {
  echo "$DEVICE_COLOR%m%f"
}

# Prints the current directory
directory() {
  echo "$DIR_COLOR%1~%f"
}

# Prints current time
current_time() {
  if [ "$PRINT_TIME" = true ]; then
    echo " $TIME_COLOR%*%f"
  fi
}

# Prints exit code of the last executed command
exit_code() {
  if [ "$PRINT_EXIT_CODE" = true ]; then
    echo "%(?..%F{001}exit %?)%f"
  fi
}

# Set git_prompt_info text
ZSH_THEME_GIT_PROMPT_PREFIX="${ON_SYMBOL}${BRANCH_COLOR}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

# %B and %b make the text bold
PROMPT='%b$(username)$AT_SYMBOL$(device)$IN_SYMBOL$(directory)$(git_prompt_info)%b $SHELL_SYMBOL '
RPROMPT="$(exit_code)$(current_time)"
