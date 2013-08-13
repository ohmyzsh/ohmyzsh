PROMPT=$'(%{$fg[red]%}%n@%m%{$reset_color%}) %F{81}%~%{$reset_color%} $(rvm_prompt_info) $(git_prompt_info)\
%F{81}↪ %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}*%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
