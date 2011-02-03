if [ $UID -eq 0 ]; then NCOLOUR="red"; else NCOLOUR="yellow"; fi

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[black]%}±"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="!"
ZSH_THEME_GIT_PROMPT_MODIFIED="!"
ZSH_THEME_GIT_PROMPT_ADDED="+"
ZSH_THEME_GIT_PROMPT_UNTRACKED="?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_HG_PROMPT_PREFIX="%{$fg_bold[black]%}☿"
ZSH_THEME_HG_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_HG_PROMPT_DIRTY="!"
ZSH_THEME_HG_PROMPT_ADDED="+"
ZSH_THEME_HG_PROMPT_UNTRACKED="?"
ZSH_THEME_HG_PROMPT_CLEAN=""

EXIT_CODE_DISPLAY="%(?.%{$fg[green]%}.%{$fg[red]%}%? )"
ZSH_THEME_EXIT_CODE=$EXIT_CODE_DISPLAY
PROMPT_COLOUR=%{$fg[$NCOLOUR]%}

PROMPT='${PROMPT_COLOUR}%D{%k:%M} %c ➤ %{$reset_color%}'
RPROMPT='${ZSH_THEME_EXIT_CODE}$(git_prompt_info)$(hg_prompt_info)%{$reset_color%}'

# See http://geoff.greer.fm/lscolors/
#               ddllssppxxbbccuuggwwoo
export LSCOLORS=exgxfxfxcxegedabagaead
export LS_COLORS='di=34;40:ln=36;40:so=35;40:pi=35;40:ex=32;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;44:ow=0;43:'

unfunction precmd
unfunction preexec

function precmd {
	settitle "%n@%m: %5(~:%-1~/.../%3~:%~)"
	}

function preexec {
	settitle "%n@%m: %5(~:%-1~/.../%3~:%~) - $1"
	}

function accept-line-and-enable-warning {
	if [ -z "$BUFFER" ]; then
		ZSH_THEME_EXIT_CODE=
		PROMPT_COLOUR=%{$fg[$NCOLOUR]%}
	else
		ZSH_THEME_EXIT_CODE=$EXIT_CODE_DISPLAY
		PROMPT_COLOUR="%(?.%{$fg[$NCOLOUR]%}.%{$fg[red]%})"
	fi
	zle accept-line
	}

zle -N accept-line-and-enable-warning
bindkey '^M' accept-line-and-enable-warning
