# Theme by Eduardo San Martin Morote aka Posva
# http://posva.github.io
# Use as you wish but don't remove this notice
# Sat May 18 16:30:33 CEST 2013 

PROMPT='%{$fg_bold[white]%}%c%{$reset_color%}:%(?.%{$FG[040]%}.%{$FG[196]%}%?)❯%{$reset_color%}'

RPROMPT='%{$fg[white]%}%{$FG[239]%}[%{$FG[033]%}%D{%H:%M:%S}%{$FG[239]%}]$(git_prompt_info)%{$reset_color%}$(git_prompt_status)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[123]%}[%{$reset_color%}%{$fg[gray]%}git%{$fg[gray]%}:%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}%{$FG[123]%}]%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[124]%} ✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[082]%} ✓%{$reset_color%}"
 
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$FG[226]%} ✭ " # ⓣ

ZSH_THEME_GIT_PROMPT_ADDED="%{$FG[082]%} ✚ " # ⓐ ⑃
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%} ⚡ "  # ⓜ ⑁
ZSH_THEME_GIT_PROMPT_DELETED="%{$FG[124]%} ✖ " # ⓧ ⑂
ZSH_THEME_GIT_PROMPT_RENAMED="%{$FG[021]%} ➜ " # ⓡ ⑄
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$FG[164]%} ♒ " # ⓤ ⑊
