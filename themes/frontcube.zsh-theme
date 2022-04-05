<<<<<<< HEAD
local rvm="%{$fg[green]%}[$(rvm-prompt i v g)]%{$reset_color%}"
=======
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b

PROMPT='
%{$fg_bold[gray]%}%~%{$fg_bold[blue]%}%{$fg_bold[blue]%} % %{$reset_color%}
%{$fg[green]%}➞  %{$reset_color%'

<<<<<<< HEAD
RPROMPT='$(git_prompt_info) $(rvm)'
=======
RPROMPT='$(git_prompt_info) $(ruby_prompt_info)'
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}[git:"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}] %{$fg[red]%}✖ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}] %{$fg[green]%}✔%{$reset_color%}"
<<<<<<< HEAD
=======
ZSH_THEME_RUBY_PROMPT_PREFIX="%{$fg[green]%}["
ZSH_THEME_RUBY_PROMPT_SUFFIX="]%{$reset_color%}"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
