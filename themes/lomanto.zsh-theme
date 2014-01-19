local ret_status="%(?:%{$FG[036]%}➜ :%{$FG[036]%}➜ %s)"
PROMPT='${ret_status}%{$FG[036]%}%p %{$FG[036]%}%c %{$FG[039]%}$(git_prompt_info)%{$FG[036]%} % %{$FG[007]%}'

ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$FG[179]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$FG[179]%}⚡%{$FG[039]%})%{$FG[007]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[039]%})"