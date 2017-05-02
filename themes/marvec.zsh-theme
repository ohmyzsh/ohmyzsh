PROMPT='%{$fg_bold[yellow]%}%D{%H:%M:%S}%{$reset_color%} [%{$fg_bold[blue]%}%n%{$fg_bold[yellow]%}@%{$fg_bold[green]%}%m%u%{$reset_color%}:%{$fg_bold[red]%}%2c%{$reset_color%}]$(git_prompt_info) %(!.#.$) '

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[blue]%}git:%{$reset_color%}(%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%})%{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%})"
