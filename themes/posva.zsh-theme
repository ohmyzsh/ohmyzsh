PROMPT='%{$FG[239]%}┌[%{$FG[040]%}%n%{$reset_color%}%{$FG[196]%}@%{$FG[208]%}%M%{$reset_color%}%{$FG[239]%}]%{$fg[white]%}-%{$FG[220]%}(%{$fg_bold[white]%}%~%{$reset_color%}%{$FG[220]%})%{$fg[white]%}-$(git_prompt_info)%{$FG[239]%}[%{$FG[033]%}%D{%H:%M:%S}%{$FG[239]%}] %(?..%{$FG[196]%}✘(%?%)%{$reset_color%})
%{$FG[239]%}└>%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[123]%}[%{$reset_color%}%{$fg[gray]%}git%{$fg[gray]%}:%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}%{$FG[123]%}]%{$fg[white]%}-"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$FG[124]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$FG[082]%}✓%{$reset_color%}"
