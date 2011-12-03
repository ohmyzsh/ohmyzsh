# Simple theme with RVM prompt

PROMPT='%{$fg[blue]%}%~%{$fg_bold[yellow]%}$(git_prompt_info)%{$reset_color%}%{$fg[blue]%}➤ %{$reset_color%}'
RPROMPT='%{$fg[blue]%}$(rvm-prompt i v p g)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" "
ZSH_THEME_GIT_PROMPT_SUFFIX=" "
ZSH_THEME_GIT_PROMPT_DIRTY=" ✗"
ZSH_THEME_GIT_PROMPT_CLEAN=" ✔"
