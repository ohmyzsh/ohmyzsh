if [[ $EUID > 0 ]] ; then
    local symbol=$
else
	local symbol=#
fi

local symbol="%(?:%{$fg_bold[green]%}${symbol}:%{$fg_bold[red]%}${symbol})"
PROMPT='${symbol} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
