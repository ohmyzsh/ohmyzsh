# The Official Theme of 
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

AT_SYMBOL=" @ "
IN_SYMBOL=" in "
ON_SYMBOL=" on "
SYMBOL="$"

USER_COLOR="%F{001}"
DEVICE_COLOR="%F{033}"
DIR_COLOR="%F{220}"
BRANCH_COLOR="%F{001}"
TIME_COLOR="%F{033}"

username() {
    echo "$USER_COLOR%n%f"
}

# Returns device name 
device() {
    echo "$DEVICE_COLOR%m%f"
}

# The current directory
directory() {
    echo "$DIR_COLOR%1~%f"
}

# Current time with milliseconds
current_time() {
    echo "$TIME_COLOR%*%f"
}

# Return status of the last command
return_status() {
    echo "%(?..%F{001}out %?)%f"
}

# Set the git_prompt_info text
ZSH_THEME_GIT_PROMPT_PREFIX="${ON_SYMBOL}${BRANCH_COLOR}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

# %B and %b make the text bold
PROMPT='%b$(username)$AT_SYMBOL$(device)$IN_SYMBOL$(directory)$(git_prompt_info)%b $SYMBOL '
RPROMPT="$(return_status) $(current_time)"
