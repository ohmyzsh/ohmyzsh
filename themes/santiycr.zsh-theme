
PROMPT='%{$fg_no_bold[cyan]%}%n %{$fg_no_bold[yellow]%}%3~%{$reset_color%} %{$fg_no_bold[magenta]%}• %{$reset_color%}'
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] || [ -n "$SSH_CONNECTION" ]; then
  PROMPT="%{$fg[yellow]%}%m%{$reset_color%} $PROMPT"
fi
RPROMPT='$(git_prompt_info) %{$reset_color%}[%*]'

# git theming
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_no_bold[green]%} ✔%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_no_bold[red]%} ✗%{$reset_color%}"
