function precmd {
	local TERMWIDTH
	(( TERMWIDTH = ${COLUMNS} - 1 ))
# Truncate the path if it's too long.    
	PR_FILLBAR=""
	PR_PWDLEN=""
	local promptsize=${#${(%):--(%n@%m)-()-(%D{%H:%M:%})-}}
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
	echo -en $reset_color
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
	ZSH_THEME_GIT_PROMPT_PREFIX="$PR_BLUE($PR_MAGENTA% git$PR_WHITE:$PR_YELLOW"
	ZSH_THEME_GIT_PROMPT_SUFFIX="$PR_BLUE)"
	ZSH_THEME_GIT_PROMPT_DIRTY=""
	ZSH_THEME_GIT_PROMPT_CLEAN=""
	ZSH_THEME_GIT_PROMPT_ADDED="$PR_BLUE($PR_GREEN✚$PR_BLUE)"
	ZSH_THEME_GIT_PROMPT_MODIFIED="$PR_BLUE($PR_BLUE✹$PR_BLUE)"
	ZSH_THEME_GIT_PROMPT_DELETED="$PR_BLUE($PR_RED✖$PR_BLUE)"
	ZSH_THEME_GIT_PROMPT_RENAMED="$PR_BLUE($PR_MAGENTA➜$PR_BLUE)"
	ZSH_THEME_GIT_PROMPT_UNMERGED="$PR_BLUE($PR_YELLOW═$PR_BLUE)"
	ZSH_THEME_GIT_PROMPT_UNTRACKED="$PR_BLUE($PR_CYAN✭$PR_BLUE)"
	
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

return_code="%(?..$PR_BLUE($PR_RED%? ↵ $PR_BLUE%))"

PROMPT='$PR_SET_CHARSET\
$PR_BLUE$PR_SHIFT_IN$PR_ULCORNER$PR_HBAR$PR_SHIFT_OUT(\
$PR_MAGENTA%n$PR_WHITE@$PR_CYAN%m$PR_BLUE)\
$PR_SHIFT_IN$PR_HBAR${(e)PR_FILLBAR}$PR_SHIFT_OUT\
($PR_MAGENTA%$PR_PWDLEN<...<%~%<<\
$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
($PR_GREEN%D{%H}$PR_WHITE:$PR_GREEN%D{%M}$PR_WHITE:$PR_GREEN%D{%S}$PR_BLUE)\

$PR_SHIFT_IN$PR_LLCORNER$PR_HBAR$PR_SHIFT_OUT$PR_NO_COLOUR\
$return_code\
`git_prompt_info`\
`git_prompt_status`\
$PR_BLUE$PR_SHIFT_IN$PR_HBAR\
$PR_GREEN❯$PR_SHIFT_OUT '

PS2='$PR_MAGENTA$PR_SHIFT_IN$PR_LLCORNER$PR_HBAR$PR_HBAR$PR_SHIFT_OUT$PR_GREEN\ '
}

setprompt