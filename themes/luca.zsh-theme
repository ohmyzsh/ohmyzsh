local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

ZSH_THEME_GIT_PROMPT_PREFIX="[%{$fg[green]%}GIT::"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}]"
ZSH_THEME_GIT_PROMPT_DIRTY="|✖"
ZSH_THEME_GIT_PROMPT_CLEAN="|✔"

ZSH_THEME_RVM_PROMPT_PREFIX="[%{$fg[red]%}RVM::"
ZSH_THEME_RVM_PROMPT_SUFFIX="%{$reset_color%}]"

# Display exitcode on the right when >0
return_code="%(?..%? ↵)"

PROMPT='
[%T] [%n] [%~] $(rvm_prompt_info) $(git_prompt_info)
→ '

RPROMPT=''