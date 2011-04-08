PROMPT='%{$fg_bold[green]%}%h %{$fg[cyan]%}%2~ %{$fg_bold[blue]%}$(vcs_prompt_info) %{$reset_color%}» '

ZSH_THEME_VCS_PROMPT_PREFIX='$(vcs_name)'"(%{$fg[red]%}"
ZSH_THEME_VCS_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_VCS_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_VCS_PROMPT_CLEAN="%{$fg[blue]%})"

