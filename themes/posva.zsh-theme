PROMPT='%{$fg[magenta]%}┌[%{$fg_bold[green]%}%n%{$reset_color%}%{$fg[red]%}@%{$fg_bold[yellow]%}%M%{$reset_color%}%{$fg[magenta]%}]%{$fg[white]%}-%{$fg[cyan]%}(%{$fg_bold[white]%}%~%{$reset_color%}%{$fg[cyan]%})$(git_prompt_info) %{$fg[blue]%}%D{[%H:%M:%S]} %(?..%{$fg[red]%}✘(%?%)%{$reset_color%})
%{$fg[magenta]%}└>%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}-[%{$reset_color%}%{$fg[gray]%}git%{$fg[gray]%}:%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}%{$fg[cyan]%}]-"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✓%{$reset_color%}"
