local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
#PROMPT='${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'
#PROMPT='${ret_status} %{$fg[white]%}%n@%m %{$fg[cyan]%}%~%{$reset_color%} $(git_prompt_info)'

if [ "x$YROOT_NAME" != "x" ]; then
  # Yroot Indicator
  # PS1="$PS1\[\033[01;35m\]$YROOT_NAME\[\033[00m\]"
  # PS1="$PS1@"
  PROMPT='${ret_status} %{$fg[grey]%}%n@%m:$YROOT_NAME %{$fg[cyan]%}%~%{$reset_color%} $(git_prompt_info)'
else
  PS1='${ret_status} %{$fg[grey]%}%n@%m %{$fg[cyan]%}%~%{$reset_color%} $(git_prompt_info)'
fi

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
#PROMPT=$PROMT:aa
