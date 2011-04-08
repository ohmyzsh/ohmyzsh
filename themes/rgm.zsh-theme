PROMPT='
%n@%m %{$fg[cyan]%}%~
%? $(vcs_prompt_info)%{$fg_bold[blue]%}%% %{$reset_color%}'

ZSH_THEME_VCS_PROMPT_PREFIX="%{$fg[red]%}"
ZSH_THEME_VCS_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_VCS_PROMPT_DIRTY="%{$fg[red]%}"
ZSH_THEME_VCS_PROMPT_CLEAN="%{$fg[blue]%}"
