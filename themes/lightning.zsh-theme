
PROMPT='%{$fg[blue]%}[%{$fg[red]%}%c$(git_prompt_info)$(git_prompt_ahead)%{$fg[blue]%}] %(?,%{$fg[green]%},%{$fg_bold[red]%})➜  %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[green]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=")%{$fg_bold[red]%}⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=")"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[yellow]%}↑%{$reset_color%}"

