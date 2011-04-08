PROMPT='$(vcs_prompt_info)%(?,,%{${fg_bold[white]}%}[%?]%{$reset_color%} )%{$fg[yellow]%}%#%{$reset_color%} '
RPROMPT='%{$fg[green]%}%~%{$reset_color%}'

ZSH_THEME_VCS_PROMPT_PREFIX="%{$fg[blue]%}("
ZSH_THEME_VCS_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_VCS_PROMPT_DIRTY="%{$fg[blue]%})%{$fg[red]%}⚡%{$reset_color%}"
ZSH_THEME_VCS_PROMPT_CLEAN="%{$fg[blue]%})"
