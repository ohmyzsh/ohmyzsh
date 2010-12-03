# Comment 

function get_host {
	echo '@'`hostname`''
}

RPROMPT='%~$(git_prompt_info)$(get_host)' 
export PS1='> '

ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"