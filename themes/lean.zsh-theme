local last_cmd_status_color="%(?,%{$fg[green]%},%{$fg[red]%})"
local rvm_prompt='$(rvm-prompt i v g)'
local git_branch='$(git_prompt_status)%{$reset_color%}$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_ADDED=""
ZSH_THEME_GIT_PROMPT_MODIFIED=""
ZSH_THEME_GIT_PROMPT_DELETED=""
ZSH_THEME_GIT_PROMPT_RENAMED=""
ZSH_THEME_GIT_PROMPT_UNMERGED=""
ZSH_THEME_GIT_PROMPT_UNTRACKED=""

ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[yellow]%}↑"
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg_bold[red]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg_bold[green]%}✔"

PROMPT='${last_cmd_status_color}[%*] %m:%~%# '
RPROMPT="%{$fg[gray]%} ${rvm_prompt} ${git_status}${git_branch}"

RPROMPT=$RPROMPT'%{$reset_color%}'
PROMPT=$PROMPT'%{$reset_color%}'
