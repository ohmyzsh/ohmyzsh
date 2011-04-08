# Simple theme based on my old zsh settings.

function get_host {
	echo '@'`hostname`''
}

PROMPT='> '
RPROMPT='%~$(vcs_prompt_info)$(get_host)'

ZSH_THEME_VCS_PROMPT_DIRTY="%{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_VCS_PROMPT_PREFIX="("
ZSH_THEME_VCS_PROMPT_SUFFIX=")"
