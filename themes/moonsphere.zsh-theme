
# Moonsphere-theme loosely based on the 'cloud' theme
# Author: Tim Kurvers <tim@moonsphere.net>
# http://www.moonsphere.net

local time="%*"
local symbol="∴"
local git_dirty="⚡"
local git_clean="☁"
local git_ahead="⤴"

function collapse_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}

function git_info() {
	ref=$(git symbolic-ref HEAD 2> /dev/null) || return

	if $(echo "$(git status 2> /dev/null)" | grep '^# Your branch is ahead' &> /dev/null); then
		ahead=$git_ahead' '
	else
		ahead=''
	fi

	if [[ -n $(git status -s 2> /dev/null) ]]; then
		echo "%{$fg_bold[yellow]%}$git_dirty ${ref#refs/heads/}$ahead %{$reset_color%}"
	else
		echo "%{$fg_bold[cyan]%}$git_clean ${ref#refs/heads/}$ahead %{$reset_color%}"
	fi
}

function virtualenv_name {
	if [ $VIRTUAL_ENV ]; then
		local name=`basename $VIRTUAL_ENV`
		if [[ $name == '.virtualenv' ]]; then
			echo `basename $VIRTUAL_ENV:h`
		else
			echo $name
		fi
	fi
}

PROMPT='%{$reset_color%}${time} $(git_info)%{$fg_bold[green]%}$(collapse_pwd) %{$fg_bold[black]%}$symbol %{$reset_color%}'
RPROMPT='%{$fg_bold[black]%}$(virtualenv_name)%{$reset_color%}'

VIRTUAL_ENV_DISABLE_PROMPT=1
