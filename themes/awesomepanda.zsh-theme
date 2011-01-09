# the svn plugin has to be activated for this to work.

PROMPT='%{$fg_bold[red]%}➜ %{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(get_scm_prompt)%{$reset_color%}'

ZSH_THEME_SCM_PROMPT_PREFIX=":(%{$fg[red]%}"
ZSH_THEME_SCM_PROMPT_SUFFIX=" %{$reset_color%}"
ZSH_THEME_SCM_PROMPT_DIRTY="%{$fg_bold[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_SCM_PROMPT_CLEAN="%{$fg_bold[blue]%})%{$reset_color%}"

ZSH_THEME_SCM_DISPLAY_NAME=1

