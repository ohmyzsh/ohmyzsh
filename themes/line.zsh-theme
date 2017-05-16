# ZSH Theme - line
# Design By LinE 
# http://blog.l1n3.net

# Define Color
local COLOR_RED="%{$fg_bold[red]%}"
local COLOR_GREEN="%{$fg_bold[green]%}"
local COLOR_YELLOW="%{$terminfo[bold]$FG[226]%}"
local COLOR_BLUE="%{$fg_bold[blue]%}"
local COLOR_MAGENTA="%{$fg_bold[magenta]%}"
local COLOR_CYAN="%{$fg_bold[cyan]%}"
local COLOR_WHITE="%{$fg_bold[white]%}"
local COLOR_RESET="%{$reset_color%}"

# ---------------- Get Host Info --------------- #
# Get User And Host
local USER_HOST="[${COLOR_MAGENTA}%n@%m${COLOR_RESET}]"

#i Get Current Directory
local CURRENT_DIR="${COLOR_CYAN}%/${COLOR_RESET}"

# Get Time
local CURRENT_TIME="${COLOR_CYAN} %D{[%Y-%m-%d %H:%M:%S]} ${COLOR_RESET}"

# Get Return Status
local RETURN_STATUS="%(?:$COLOR_GREEN➜ $COLOR_RESET:$COLOR_RED➜ $COLOR_RESET)"

# Get Git Info
local GIT_BRANCH=$'${COLOR_BLUE}$(git_prompt_info) $(git_prompt_short_sha) $(git_prompt_status)'

# ---------------- Set Format --------------- #
# Format For PROMPT
PROMPT="${USER_HOST}: ${CURRENT_DIR} ${GIT_BRANCH}
${RETURN_STATUS} "

# Format For RPS1
RPS1="${CURRENT_TIME}"

# ---------------- Git --------------- #
# Format for git_prompt_info()
ZSH_THEME_GIT_PROMPT_PREFIX="git:(${COLOR_YELLOW}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${COLOR_RESET}"

# Format for parse_git_dirty()
ZSH_THEME_GIT_PROMPT_DIRTY="${COLOR_BLUE}) ${COLOR_RED}✗${COLOR_RESET}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="[${COLOR_WHITE}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="${COLOR_RESET}]"

# Format for git_prompt_status()
ZSH_THEME_GIT_PROMPT_UNMERGED="${COLOR_RED}Unmerged "
ZSH_THEME_GIT_PROMPT_DELETED="${COLOR_RED}Deleted "
ZSH_THEME_GIT_PROMPT_RENAMED="${COLOR_YELLOW}Renamed "
ZSH_THEME_GIT_PROMPT_MODIFIED="${COLOR_YELLOW}Modified "
ZSH_THEME_GIT_PROMPT_ADDED="${COLOR_GREEN}Added "
ZSH_THEME_GIT_PROMPT_UNTRACKED="${COLOR_WHITE}Untracked "
