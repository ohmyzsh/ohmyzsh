# jaischeema.zsh-theme

PROMPT='%{$fg_bold[magenta]%}%m%{$reset_color%} at %{$fg_bold[green]%}%~%{$reset_color%} %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%}% %{$reset_color%}%{$fg[red]%}❯%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="±(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}) "

if which rbenv &> /dev/null; then
  RPROMPT='%{$fg[red]%}$(rbenv version | sed -e "s/ (set.*$//")%{$reset_color%}'
else
  if which rvm-prompt &> /dev/null; then
    RPROMPT='%{$fg[red]%}$(rvm-prompt)%{$reset_color%}'
  fi
fi
