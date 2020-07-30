# Simple theme based on my old zsh settings.

function get_host {
	echo '@'$HOST
}

PROMPT='> '
RPROMPT='%~$(git_prompt_info)$(get_host)'

ZSH_THEME_GIT_PROMPT_DIRTY="%F{yellow}✗%f"
ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
