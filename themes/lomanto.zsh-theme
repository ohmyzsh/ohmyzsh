# Preview different colors in terminal by running `spectrum_ls`

local ret_status="%(?:%{$FG[036]%}➜ :%{$FG[036]%}➜ %s)"
PROMPT='${ret_status}%{$FG[036]%}%p %{$FG[036]%}%c %{$FG[141]%}$(git_prompt_info)%{$FG[141]%} % %{$FG[255]%}'

ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$FG[141]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$FG[255]%}⚡%{$FG[141]%})%{$FG[255]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[141]%})"