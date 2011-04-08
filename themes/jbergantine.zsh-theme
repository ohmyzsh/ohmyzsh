PROMPT='%{$fg_bold[red]%}➜ %{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[white]%}$(vcs_prompt_info)%{$fg_bold[white]%} % %{$reset_color%}'

ZSH_THEME_VCS_PROMPT_PREFIX='$(vcs_name)'"(%{$fg[red]%}"
ZSH_THEME_VCS_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_VCS_PROMPT_DIRTY="%{$fg[white]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_VCS_PROMPT_CLEAN="%{$fg[white]%})"
