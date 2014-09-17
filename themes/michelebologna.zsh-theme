# Michele Bologna theme
# mbologna on GitHub
#
# reference colors
local GREEN="%{$fg_bold[green]%}"
local RED="%{$fg_bold[red]%}"
local CYAN="%{$fg_bold[cyan]%}"
local YELLOW="%{$fg_bold[yellow]%}"
local BLUE="%{$fg_bold[blue]%}"
local MAGENTA="%{$fg_bold[magenta]%}"
local WHITE="%{$fg_bold[white]%}"

local COLOR_ARRAY
COLOR_ARRAY=($GREEN $RED $CYAN $YELLOW $BLUE $MAGENTA $WHITE)

# color reset
local RESET_COLOR="%{$reset_color%}"

# which color should be applied?
local USERNAME_NORMAL_COLOR=$WHITE
local USERNAME_ROOT_COLOR=$RED
for i in `hostname`; local HOSTNAME_NORMAL_COLOR=$COLOR_ARRAY[$[((#i))%7+1]]
local HOSTNAME_ROOT_COLOR=$RED
local HOSTNAME_COLOR
HOSTNAME_COLOR=%(!.$HOSTNAME_ROOT_COLOR.$HOSTNAME_NORMAL_COLOR)
local CURRENT_DIR_COLOR=$CYAN

# zsh commands
local USERNAME_COMMAND="%n"
local HOSTNAME_COMMAND="%m"
local CURRENT_DIR="%~"

# output: colors + commands
local USERNAME_OUTPUT="%(!..$USERNAME_NORMAL_COLOR$USERNAME_COMMAND$RESET_COLOR@)"
local HOSTNAME_OUTPUT="$HOSTNAME_COLOR$HOSTNAME_COMMAND$RESET_COLOR"
local CURRENT_DIR_OUTPUT="$CURRENT_DIR_COLOR$CURRENT_DIR"
local LAST_COMMAND_OUTPUT="%(?.%(!.$RED.$GREEN).$YELLOW)"

# git theming
local ZSH_THEME_GIT_PROMPT_PREFIX="("
local ZSH_THEME_GIT_PROMPT_SUFFIX=""
local ZSH_THEME_GIT_PROMPT_DIRTY=")$RED*"
local ZSH_THEME_GIT_PROMPT_CLEAN=")"

# wrap all together
export PROMPT='$USERNAME_OUTPUT$HOSTNAME_OUTPUT:$CURRENT_DIR_OUTPUT $LAST_COMMAND_OUTPUT%#$RESET_COLOR '
export RPROMPT='%1(j.fg: [%j].) $GREEN$(git_prompt_info)$RESET_COLOR [%@]'
