function precmd {
	local TERMWIDTH
	(( TERMWIDTH = ${COLUMNS} - 1 ))
# Truncate the path if it's too long.    
	PR_FILLBAR=""
	PR_PWDLEN=""
	local promptsize=${#${(%):---(%n@%m:%l)---()--}}
	local rubyprompt=`rvm_prompt_info`
	local rubypromptsize=${#${rubyprompt}}
	local pwdsize=${#${(%):-%~}}
	if [[ "$promptsize + $rubypromptsize + $pwdsize" -gt $TERMWIDTH ]]; then
		((PR_PWDLEN=$TERMWIDTH - $promptsize))
	else
		PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $rubypromptsize + $pwdsize)))..${PR_HBAR}.)}"
	fi
}

setopt extended_glob
preexec () {
	if [[ "$TERM" == "screen" ]]; then
		local CMD=${1[(wr)^(*=*|sudo|-*)]}
		echo -n "\ek$CMD\e\\"
	fi
}

setprompt () {
# Need this so the prompt will work.
	setopt prompt_subst

# See if we can use colors.
	autoload colors zsh/terminfo
	if [[ "$terminfo[colors]" -ge 8 ]]; then
		colors
	fi
	for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE GREY; do
		eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
		eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
		(( count = $count + 1 ))
	done
	PR_NO_COLOUR="%{$terminfo[sgr0]%}"

# Modify Git prompt
	ZSH_THEME_GIT_PROMPT_PREFIX="(%{$fg_bold[blue]%}git:%{$reset_color%}%{$fg_bold[yellow]%}"
	ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"
	ZSH_THEME_GIT_PROMPT_DIRTY=""
	ZSH_THEME_GIT_PROMPT_CLEAN=""
	ZSH_THEME_GIT_PROMPT_ADDED="(%{$fg[green]%}✚%{$reset_color%})"
	ZSH_THEME_GIT_PROMPT_MODIFIED="(%{$fg[blue]%}✹%{$reset_color%})"
	ZSH_THEME_GIT_PROMPT_DELETED="(%{$fg[red]%}✖%{$reset_color%})"
	ZSH_THEME_GIT_PROMPT_RENAMED="(%{$fg[magenta]%}➜%{$reset_color%})"
	ZSH_THEME_GIT_PROMPT_UNMERGED="(%{$fg[yellow]%}═%{$reset_color%})"
	ZSH_THEME_GIT_PROMPT_UNTRACKED="(%{$fg[cyan]%}✭%{$reset_color%})"
	
# See if we can use extended characters to look nicer.
	typeset -A altchar
	set -A altchar ${(s..)terminfo[acsc]}
	PR_SET_CHARSET="%{$terminfo[enacs]%}"
	PR_SHIFT_IN="%{$terminfo[smacs]%}"
	PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
	PR_HBAR=${altchar[q]:--}
	PR_ULCORNER=${altchar[l]:--}
	PR_LLCORNER=${altchar[m]:--}
	PR_LRCORNER=${altchar[j]:--}
	PR_URCORNER=${altchar[k]:--}

# Decide if we need to set titlebar text.
	case $TERM in
	xterm*)
		PR_TITLEBAR=$'%{\e]0;%(!.-=*[ROOT]*=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\a%}'
		;;
	screen)
		PR_TITLEBAR=$'%{\e_screen \005 (\005t) | %(!.-=[ROOT]=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\e\\%}'
		;;
	*)
		PR_TITLEBAR=''
		;;
	esac
	
# Decide whether to set a screen title
	if [[ "$TERM" == "screen" ]]; then
		PR_STITLE=$'%{\ekzsh\e\\%}'
	else
		PR_STITLE=''
	fi

PROMPT='$PR_SET_CHARSET\
$PR_SHIFT_IN$PR_ULCORNER$PR_HBAR$PR_SHIFT_OUT$PR_NO_COLOUR(\
$PR_MAGENTA%n$PR_NO_COLOUR@$PR_BLUE%m$PR_NO_COLOUR)\
$PR_SHIFT_IN$PR_HBAR$PR_HBAR${(e)PR_FILLBAR}$PR_HBAR\
$PR_HBAR$PR_HBAR$PR_HBAR$PR_HBAR$PR_HBAR$PR_SHIFT_OUT\
$PR_NO_COLOUR($PR_BLUE%$PR_PWDLEN<...<%~%<<\
$PR_NO_COLOUR)\
$PR_SHIFT_IN$PR_HBAR$PR_URCORNER$PR_SHIFT_OUT\

$PR_SHIFT_IN$PR_LLCORNER$PR_HBAR$PR_SHIFT_OUT$PR_NO_COLOUR\
`git_prompt_info`\
`git_prompt_status`\
$PR_SHIFT_IN$PR_HBAR\
$PR_GREEN❯$PR_NO_COLOUR '

# display exitcode on the right when >0
return_code="%(?..%{$fg[red]%}%? ↵ %{$reset_color%})"
RPROMPT='$return_code($PR_GREEN%D{%H:%M:%S}$PR_NO_COLOUR)$PR_SHIFT_IN$PR_HBAR$PR_LRCORNER$PR_SHIFT_OUT$PR_NO_COLOUR'

PS2='$PR_SHIFT_IN$PR_LLCORNER$PR_HBAR$PR_SHIFT_OUT$PR_NO_COLOUR\'
}

setprompt