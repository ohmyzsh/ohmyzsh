ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[yellow]%}?%{$reset_color%}%{$fg_bold[red]%}git%{$reset_color%}%{$fg_bold[yellow]%}=%{$reset_color%}%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

PROMPT='%(0?..%{$fg_bold[yellow]%}[%{$reset_color%}%{$fg_bold[red]%}%?%{$reset_color%}%{$fg_bold[yellow]%}]%{$reset_color%}
)%{$fg_bold[green]%}%n%{$reset_color%}%{$fg_bold[yellow]%}@%{$reset_color%}%{$fg_bold[green]%}%M%{$reset_color%}%{$fg_bold[blue]%}%d%{$reset_color%}$(git_prompt_info)
%{$fg_bold[yellow]%}%#%{$reset_color%} '
