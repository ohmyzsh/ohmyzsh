<<<<<<< HEAD
# ZSH Theme - Preview: http://gyazo.com/8becc8a7ed5ab54a0262a470555c3eed.png
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

if [ -e ~/.rvm/bin/rvm-prompt ]; then
  PROMPT='%{$fg[green]%}%~%{$reset_color%} %{$fg[red]%}‹$(~/.rvm/bin/rvm-prompt i v)› %{$reset_color%} $(git_prompt_info)%{$reset_color%}%B$%b '
else
  if which rbenv &> /dev/null; then
    PROMPT='%{$fg[green]%}%~%{$reset_color%} %{$fg[red]%}‹$(rbenv version | sed -e "s/ (set.*$//")› %{$reset_color%} $(git_prompt_info)%{$reset_color%}%B$%b '
  fi
fi
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"
=======
# ZSH Theme - Preview: https://i.gyazo.com/8becc8a7ed5ab54a0262a470555c3eed.png
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

PROMPT='%{$fg[green]%}%~%{$reset_color%} $(ruby_prompt_info) $(git_prompt_info)%{$reset_color%}%B$%b '
RPROMPT="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"


ZSH_THEME_RUBY_PROMPT_PREFIX="%{$fg[red]%}‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="› %{$reset_color%}"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
