ps1='%S%B[%n@%m]%s%b %! %3(~|~/%B...%b/%2~|%~)$(git_prompt_info)%B%F{green}]%f%b '
ps2='%_%B%F{green}>%f%b '

PROMPT=$ps1
PROMPT2=$ps2
RPS1='%F{yellow}$(git_prompt_status)%f %(?|%F{green}%?%f|%F{yellow}%?%f)(%j) %T'

function zle-keymap-select zle-line-init { 	
	if [[ $KEYMAP == 'vicmd' ]] { 
		PROMPT=${ps1//green/red} 
		PROMPT2=${ps2//green/red} 
	} else {
		PROMPT=$ps1
		PROMPT2=$ps2
	}
	zle reset-prompt
}
function zle-line-finish {
	PROMPT=$ps1
	PROMPT2=$ps2
	zle reset-prompt
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

ZSH_THEME_GIT_PROMPT_PREFIX=" git:"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_CLEAN_PREFIX="%{$fg[green]%}("
ZSH_THEME_GIT_PROMPT_DIRTY_PREFIX="%{$fg[yellow]%}("
ZSH_THEME_GIT_PROMPT_CLEAN=")%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=")%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_UNTRACKED="?"
ZSH_THEME_GIT_PROMPT_ADDED="+"
ZSH_THEME_GIT_PROMPT_MODIFIED="!"
ZSH_THEME_GIT_PROMPT_RENAMED="R"
ZSH_THEME_GIT_PROMPT_DELETED="-"
ZSH_THEME_GIT_PROMPT_UNMERGED="U"
