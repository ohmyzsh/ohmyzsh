<<<<<<< HEAD
PROMPT=$'%{$fg[white]%}$(~/.rvm/bin/rvm-prompt) %{$fg_bold[cyan]%}%~%{$reset_color%}$(git_prompt_info) %{$fg[cyan]%}%D{[%I:%M:%S]}\
=======
PROMPT=$'%{$fg[white]%}$(ruby_prompt_info) %{$fg_bold[cyan]%}%~%{$reset_color%}$(git_prompt_info) %{$fg[cyan]%}%D{[%I:%M:%S]}\
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
%{$fg_bold[green]%}%n$%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[white]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""
