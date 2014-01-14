#usage: title short_tab_title looooooooooooooooooooooggggggg_windows_title
#http://www.faqs.org/docs/Linux-mini/Xterm-Title.html#ss3.1
#Fully support screen, iterm, and probably most modern xterm and rxvt
#Limited support for Apple Terminal (Terminal can't set window or tab separately)
function title {
	if [[ "$DISABLE_AUTO_TITLE" == "true" ]] || [[ "$EMACS" == *term* ]]; then
		return
	fi
	if [[ "$TERM" == screen* ]]; then
		print -Pn "\ek$1:q\e\\" #set screen hardstatus, usually truncated at 20 chars
	elif [[ "$TERM" == xterm* ]] || [[ $TERM == rxvt* ]] || [[ $TERM == ansi ]] || [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
		print -Pn "\e]2;$2:q\a" #set window name
		print -Pn "\e]1;$1:q\a" #set icon (=tab) name (will override window name on broken terminal)
	fi
}

ZSH_THEME_TERM_TAB_TITLE_IDLE="%15<..<%~%<<" #15 char left truncated PWD
ZSH_THEME_TERM_TITLE_IDLE="%n@%m: %~"

#Appears when you have the prompt
function omz_termsupport_precmd {
	title $ZSH_THEME_TERM_TAB_TITLE_IDLE $ZSH_THEME_TERM_TITLE_IDLE
}

#Appears at the beginning of (and during) of command execution
function omz_termsupport_preexec {
	emulate -L zsh
	setopt extended_glob
	local CMD=${1[(wr)^(*=*|sudo|ssh|rake|-*)]} #cmd name only, or if this is sudo or ssh, the next cmd
	local LINE=${2}

	if [[ -o PROMPT_BANG ]]; then
		# We must escape ! so that it is not interpreted as a history event number
		LINE=${LINE:gs/\!/\!\!}
		CMD=${CMD:gs/\!/\!\!}
	fi

	if [[ -o PROMPT_SUBST ]]; then
		# We must escape '\', '$', and '`'
		# The backslash is the escape character, and so must be escaped first.
		# Both '$' and '`' initiate command substitution, and
		# the former initiates arithmetic and parameter expansion
		CMD=${CMD:gs/\\/\\\\} # escapses \ -- must be first
		CMD=${CMD:gs/$/\\$}
		CMD=${CMD:gs/\`/\\\`}
		local LINE=${LINE:gs/\\/\\\\} # escapes \ -- must be first
		LINE=${LINE:gs/$/\\$}
		LINE=${LINE:gs/\`/\\\`}
	fi

	if [[ -o PROMPT_PERCENT ]]; then
		# We must escape % so that it is not interpreted as starting an escape sequence
		CMD=${CMD:gs/%/%%}
		LINE=${LINE:gs/%/%%}
	fi
	title "$CMD" "%100>...>$LINE%<<"
}

autoload -U add-zsh-hook
add-zsh-hook precmd omz_termsupport_precmd
add-zsh-hook preexec omz_termsupport_preexec
