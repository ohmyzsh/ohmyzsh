function prompt_char {
    if [ $UID -eq 0 ]; then echo "#"; else echo $; fi
}

PROMPT='%{$fg_bold[red]%}➜ %{$fg_bold[green]%}%n%{$fg[cyan]%}@%{$fg_bold[green]%}%m %{$fg_bold[green]%}%p %{$fg[cyan]%}%~ %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} %_$(prompt_char) % %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
