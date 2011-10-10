function title {
  [ "$DISABLE_AUTO_TITLE" != "true" ] || return
  if [[ "$TERM" == screen* ]]; then 
    print -Pn "\ek$1:q\e\\"
  elif [[ "$TERM" == xterm* ]] || [[ $TERM == rxvt* ]] || [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    print -Pn "\e]2;$2:q\a"
    print -Pn "\e]1;$1:q\a"
  fi
}

ZSH_THEME_TERM_TAB_TITLE_IDLE="%15<..<%~%<<"
ZSH_THEME_TERM_TITLE_IDLE="%n@%m: %~"

function precmd {
	local TERMWIDTH
	(( TERMWIDTH = ${COLUMNS} - 1 ))
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
	title $ZSH_THEME_TERM_TAB_TITLE_IDLE $ZSH_THEME_TERM_TITLE_IDLE
}

setopt extended_glob
preexec () {
	if [[ "$TERM" == "screen" ]]; then
		local CMD=${1[(wr)^(*=*|sudo|-*)]}
		echo -n "\ek$CMD\e\\"
	fi
	local CMD=${1[(wr)^(*=*|sudo|ssh|-*)]}
	title "$CMD" "%100>...>$2%<<"
	echo -en $reset_color
}

function battery_charge {
	$ZSH/lib/battcharge.py
	echo `$BAT_CHARGE` 2>/dev/null
}

setprompt () {
# Need this so the prompt will work.
	setopt prompt_subst
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
	ZSH_THEME_GIT_PROMPT_PREFIX="$PR_MAGENTA($PR_BLUE% git:$PR_YELLOW"
	ZSH_THEME_GIT_PROMPT_SUFFIX="$PR_MAGENTA)"
	ZSH_THEME_GIT_PROMPT_DIRTY=""
	ZSH_THEME_GIT_PROMPT_CLEAN=""
	ZSH_THEME_GIT_PROMPT_ADDED="$PR_MAGENTA($PR_GREEN✚$PR_MAGENTA)"
	ZSH_THEME_GIT_PROMPT_MODIFIED="$PR_MAGENTA($PR_BLUE✹$PR_MAGENTA)"
	ZSH_THEME_GIT_PROMPT_DELETED="$PR_MAGENTA($PR_RED✖$PR_MAGENTA)"
	ZSH_THEME_GIT_PROMPT_RENAMED="$PR_MAGENTA($PR_MAGENTA➜$PR_MAGENTA)"
	ZSH_THEME_GIT_PROMPT_UNMERGED="$PR_MAGENTA($PR_YELLOW═$PR_MAGENTA)"
	ZSH_THEME_GIT_PROMPT_UNTRACKED="$PR_MAGENTA($PR_CYAN✭$PR_MAGENTA)"
	
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

# set return code to display if greater than zero
	return_code="%(?..$PR_MAGENTA($PR_RED%?↩ $PR_MAGENTA%))"

PROMPT='$PR_SET_CHARSET\
$PR_MAGENTA$PR_SHIFT_IN$PR_ULCORNER$PR_HBAR$PR_SHIFT_OUT(\
$PR_BLUE%n$PR_MAGENTA@$PR_CYAN%m$PR_MAGENTA)\
$PR_SHIFT_IN$PR_HBAR${(e)PR_FILLBAR}$PR_SHIFT_OUT\
($PR_BLUE%$PR_PWDLEN<...<%~%<<\
$PR_MAGENTA)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
($PR_GREEN%D{%H}$PR_MAGENTA:$PR_GREEN%D{%M}$PR_MAGENTA:$PR_GREEN%D{%S}$PR_MAGENTA)\

$PR_SHIFT_IN$PR_LLCORNER$PR_HBAR$PR_SHIFT_OUT$PR_NO_COLOUR\
$return_code\
`git_prompt_info`\
`git_prompt_status`\
$PR_MAGENTA$PR_SHIFT_IN$PR_HBAR\
$PR_GREEN❯$PR_SHIFT_OUT '

RPROMPT='$(battery_charge)$PR_GREEN'

PS2='$PR_MAGENTA$PR_SHIFT_IN$PR_LLCORNER$PR_HBAR$PR_HBAR$PR_SHIFT_OUT$PR_GREEN\ '
}

setprompt