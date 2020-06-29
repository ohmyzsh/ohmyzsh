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

export AT_SYMBOL=" @ "
export IN_SYMBOL=" in "
export ON_SYMBOL=" on "
export SYMBOL="$"

export USER_COLOR="%{$FG[001]%}"
export DEVICE_COLOR="%{$FG[033]%}"
export DIR_COLOR="%{$FG[220]%}"
export BRANCH_COLOR="%{$FG[001]%}"
export TIME_COLOR="%{$FG[033]%}"

username() {
   echo "$USER_COLOR%n%{$reset_color%}"
}

# Returns device name 
device() {
   echo "$DEVICE_COLOR%m%{$reset_color%}"
}

# The current directory
directory() {
   echo "$DIR_COLOR%1~%{$reset_color%}"
}

# Current time with milliseconds
current_time() {
   echo "$TIME_COLOR%*%{$reset_color%}"
}

# Return status of the last command
return_status() {
   echo "%(?..%{$FG[001]%}out %?)%{$reset_color%}"
}

# Set the git_prompt_info text
ZSH_THEME_GIT_PROMPT_PREFIX="${ON_SYMBOL}${BRANCH_COLOR}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

# %B and %b make the text bold
PROMPT='%b$(username)$AT_SYMBOL$(device)$IN_SYMBOL$(directory)$(git_prompt_info)%b $SYMBOL '
RPROMPT="$(return_status) $(current_time)"
