# meh. Dark Blood Rewind, a new beginning.

PROMPT=$'%{$fg[red]%}┌[%{$fg_bold[white]%}%n%{$reset_color%}%{$fg[red]%}@%{$fg_bold[white]%}%m%{$reset_color%}%{$fg[red]%}] [%{$fg_bold[white]%}/dev/%y%{$reset_color%}%{$fg[red]%}] %{$(vcs_prompt_info)%}%(?,,%{$fg[red]%}[%{$fg_bold[white]%}%?%{$reset_color%}%{$fg[red]%}])
%{$fg[red]%}└[%{$fg_bold[white]%}%~%{$reset_color%}%{$fg[red]%}]>%{$reset_color%} '
PS2=$' %{$fg[red]%}|>%{$reset_color%} '

ZSH_THEME_VCS_PROMPT_PREFIX="%{$fg[red]%}[%{$fg_bold[white]%}"
ZSH_THEME_VCS_PROMPT_SUFFIX="%{$reset_color%}%{$fg[red]%}] "
ZSH_THEME_VCS_PROMPT_DIRTY=" %{$fg[red]%}⚡%{$reset_color%}"
