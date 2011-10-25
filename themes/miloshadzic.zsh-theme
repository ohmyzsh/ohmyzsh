# Yay! High voltage, arrows and kings!
#
# Some features in this theme are flagable:
#
# ZSH_THEME_PREFIX_ROOT=1
#   >> Prefix the prompt with a red crown if the 
#      current user is root
#
# ZSH_THEME_USE_RPROMPT=1
#   >> Display the last return code in red in the
#      right prompt. But only if the code was not zero.
#

# Configuration for $(git_prompt_info)
ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Some variables to make things readable
local directory="%{$fg[cyan]%}%1~%{$reset_color%}"
local left_delimiter="%{$fg[red]%}|%{$reset_color%}"
local right_delimiter=" %{$fg[cyan]%}⇒%{$reset_color%} "

if [[ "$ZSH_THEME_PREFIX_ROOT" != "" && "$UID" -eq 0 ]]; then 
    local root_prefix="%{$fg[red]%}♚ %{$reset_color%}"
else
    local root_prefix=""
fi

PROMPT='${root_prefix}${directory}${left_delimiter}$(git_prompt_info)${right_delimiter}'

# And finally the RPROMPT if activated
if [ "$ZSH_THEME_USE_RPROMPT" != "" ]; then
    local return_code="%(?..%{$fg[red]%}%?%{$reset_color%})"
    RPROMPT='${return_code}'
fi
