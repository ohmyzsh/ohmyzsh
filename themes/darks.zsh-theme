#!/usr/bin/env zsh
# #
# # Darks ZSH Theme
# #
# # enjoy!
########## functions ###########
_my_user() {
    echo "%{$fg_bold[red]%}$USER@%{$reset_color%}"
}

_my_machine() {
    echo "%{$fg_bold[green]%}%m:%{$reset_color%}"
}

my_git_prompt_info() {
	ref=$(git symbolic-ref HEAD 2> /dev/null) || return
	GIT_STATUS=$(git_prompt_status)
	[[ -n $GIT_STATUS ]] && GIT_STATUS=" $GIT_STATUS"
	echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$GIT_STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

_my_actual_path() {
    echo "%{$fg[blue]%}$PWD%{$reset_color%}"
}

_my_user_dash() {
    echo "%{$fg[red]%}%(!.#.$)%{$reset_color%}"
}

#Killed functions
#at_seperator() {
#    echo "%{$fg_bold[red]%}@%{$reset_color%}"
#}

#doubledot_seperator() {
#    echo "%{$fg[green]%}:%{$reset_color%}"
#}

PROMPT='$(_my_user)$(_my_machine)$(_my_actual_path)$(_my_user_dash)$(my_git_prompt_info)
▶ '

# ########## GIT ###########
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[yellow]%}git:("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="${VCS_DIRTY_COLOR} ✘${VCS_SUFIX_COLOR}"
ZSH_THEME_GIT_PROMPT_CLEAN="${VCS_CLEAN_COLOR} ✔${VCS_SUFIX_COLOR}"
ZSH_THEME_GIT_PROMPT_UNMERGED="${PR_RESET}${PR_YELLOW} ✖${PR_RESET}"
