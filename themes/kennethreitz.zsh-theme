local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

<<<<<<< HEAD
PROMPT='%{$fg[green]%}%c \
$(git_prompt_info)\
=======
PROMPT='$(virtualenv_prompt_info)%{[03m%}%{$fg[green]%}%c \
$(git_prompt_info)\
\
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
%{$fg[red]%}%(!.#.»)%{$reset_color%} '
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'
RPS1='%{$fg[blue]%}%~%{$reset_color%} ${return_code} '

<<<<<<< HEAD
ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}:: %{$fg[yellow]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$fg[yellow]%}"

=======
ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[yellow]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$fg[yellow]%}"
ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX="%{$reset_color%}%{[03m%}%{$fg[blue]%}"
ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX="!%{$reset_color%} "
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
