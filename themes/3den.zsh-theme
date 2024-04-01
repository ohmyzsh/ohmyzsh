PROMPT=$'%{$fg[]%}$(ruby_prompt_info) %{$fg_bold[]%}%~%{$reset_%}$(git_prompt_info) %{$fg[]%}%D{[]}\
%{$fg_bold[]%}%n$%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""
