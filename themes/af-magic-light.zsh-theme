# af-magic-light.zsh-theme
#
# Author: Andreas Pohle (thanks to Andy Fleming http://andyfleming.com/)
# URL: http://apoh.de/
# Repo: https://github.com/apoh/oh-my-zsh
#
# This is a light version of Andy Flemings af-magic theme
# 
# Created on:		March 14, 2014
# Last modified on:	March 14, 2014

if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi
local return_code="%(?..%{$fg[red]%}%? %{$reset_color%})"

# primary prompt
PROMPT='$FG[032]%~\
$(git_prompt_info) \
$FG[105]%(!.#.${return_code}»)%{$reset_color%} '
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'
RPS1='${return_code}'


# color vars
eval my_gray='$FG[237]'
eval my_orange='$FG[214]'

# right prompt
if type "virtualenv_prompt_info" > /dev/null
then
	RPROMPT='$(virtualenv_prompt_info)$my_gray%n@%m%{$reset_color%}%'
else
	RPROMPT='$my_gray%n@%m%{$reset_color%}%'
fi

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX="$FG[075]("
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="$my_orange*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$FG[075])%{$reset_color%}"
