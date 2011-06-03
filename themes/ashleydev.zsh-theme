# ------------------------------------------------------------------------------
#          FILE:  ashleydev.theme.zsh
#   DESCRIPTION:  oh-my-zsh prompt theme, shows vi mode, last shell return code,
#                 and verbose git info.
#        AUTHOR:  Ashley Dev (the.ashley.dev+zsh-theme@gmail.com)
#       VERSION:  3.0
#    SCREENSHOT:  http://i.imgur.com/Yw1KG.png
#                 http://i.imgur.com/wx6MU.png
# ------------------------------------------------------------------------------

# NOTE: make sure to add 'git' to your list of oh-my-zsh plugins (in your
# ~/.zshrc), otherwise the git prompt info will not be shown.

#-------------------- Colors ----------------------
# Colors ('_C' for color):
if [[ "$DISABLE_COLOR" != "true" ]]; then
    # Reset formating:
    local R="%{$terminfo[sgr0]%}"

    # PROMPT colors:
    local _Cuser_root_="%{$fg_bold[yellow]$bg[red]%}"
    local _Chost_root_="%{$fg[red]%}"
    local _Cpath_root_="%{$fg_bold[white]%}"
    local _Cuser_="%{$fg_bold[cyan]%}"
    local _Chost_="%{$fg_bold[blue]%}"
    local _Cpath_="%{$fg_bold[white]%}"
    local _Cjobs_="%{$fg[blue]%}"

    # RPROMPT colors:
    local _Cdate_="%{$fg[green]%}"
    local _Creturn_code_="%{$fg[red]%}"
    local _Cvi_mode_="%{$fg_bold[cyan]%}"
fi

#-------------------- PROMPT definition: ----------------------
#
local user_="%(!.$_Cuser_root_.$_Cuser_)%n$R"
local host_="%(!.$_Chost_root_.$_Chost_)%m$R"
local path_="%(!.$_Cpath_root_.$_Cpath_)%~$R"
local jobs_="%(1j.$_Cjobs_%j$R.)"

PROMPT='$user_$host_$path_ $(git_prompt_info2)$jobs_# '

local date_format_='%D{%a %b %d}, %*'
local date_="${_Cdate_}[$date_format_]$R"
local return_code_="%(?..$_Creturn_code_%? ↵ )$R"

RPROMPT='$return_code_$date_'

# use the vi-mode oh-my-zsh plugin to get this:
MODE_INDICATOR="${_Cvi_mode_}-- CMD MODE -- $R"
