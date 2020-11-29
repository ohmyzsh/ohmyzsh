PROMPT="$fg[blue]⌊$fg[green] %~ $reset_color$fg[blue]⌉$reset_color"
PROMPT+=' %{$fg[blue]%}%c%{$reset_color%} $(git_prompt_info)
▲ '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
