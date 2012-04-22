function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "%{$fg_bold[cyan]%}☁ "
  fi
}

PROMPT='%{$fg_bold[green]%}%p%{$fg[magenta]%}%c %{$fg_bold[blue]%}$(ssh_connection)%{$fg_bold[yellow]%}⚡ % %{$reset_color%}'

RPROMPT='%{$fg[yellow]%}$(rvm_prompt_info) %{$fg_bold[blue]%}$(git_prompt_info) %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="git:[%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}] %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}]"
