PROMPT="%(?:%{$fg[green]%}➜ :%{$fg[red]%}➜ )"
PROMPT+='%{$fg[cyan]%}%2c%{$reset_color%}$(git_prompt_info) '

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[red]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=") %{$fg[green]%}✔%{$reset_color%}"

