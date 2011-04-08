PROMPT=$'%{$fg_bold[green]%}%n@%m %{$fg[blue]%}%D{[%I:%M:%S]} %{$reset_color%}%{$fg[white]%}[%~]%{$reset_color%} $(vcs_prompt_info)\
%{$fg[blue]%}->%{$fg_bold[blue]%} %#%{$reset_color%} '

ZSH_THEME_VCS_PROMPT_PREFIX="%{$fg[green]%}["
ZSH_THEME_VCS_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_VCS_PROMPT_DIRTY=" %{$fg[red]%}*%{$fg[green]%}"
ZSH_THEME_VCS_PROMPT_CLEAN=""
