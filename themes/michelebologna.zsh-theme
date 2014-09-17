# Michele Bologna's theme
# http://michelebologna.net
#
# This a theme for oh-my-zsh. Features a colored prompt with a right prompt 
# containing the git status (if applicable).
# The '%' prompt will be green if last command return value is 0, yellow otherwise.
# The hostname color is based on hostname characters (see below).
# When using as root, the left prompt shows only the hostname in red color.
#

local green="%{$fg_bold[green]%}"
local red="%{$fg_bold[red]%}"
local cyan="%{$fg_bold[cyan]%}"
local yellow="%{$fg_bold[yellow]%}"
local blue="%{$fg_bold[blue]%}"
local magenta="%{$fg_bold[magenta]%}"
local white="%{$fg_bold[white]%}"
local reset="%{$reset_color%}"

local color_array
color_array=($green $red $cyan $yellow $blue $magenta $white)

local username_normal_color=$white
local username_root_color=$red
local hostname_root_color=$red

# calculating the hostname color with hostname characters
for i in `hostname`; local hostname_normal_color=$color_array[$[((#i))%7+1]]

local hostname_color
hostname_color=%(!.$hostname_root_color.$hostname_normal_color)
local current_dir_color=$cyan

local username_command="%n"
local hostname_command="%m"
local current_dir="%~"

local username_output="%(!..$username_normal_color$username_command$reset@)"
local hostname_output="$hostname_color$hostname_command$reset"
local current_dir_output="$current_dir_color$current_dir"
local last_command_output="%(?.%(!.$red.$green).$yellow)"

export ZSH_THEME_GIT_PROMPT_PREFIX="("
export ZSH_THEME_GIT_PROMPT_SUFFIX=""
export ZSH_THEME_GIT_PROMPT_DIRTY=")$red*"
export ZSH_THEME_GIT_PROMPT_CLEAN=")"

export PROMPT='$username_output$hostname_output:$current_dir_output $last_command_output%#$reset '
export RPROMPT='%1(j.fg: [%j].) $green$(git_prompt_info)$reset [%@]'
