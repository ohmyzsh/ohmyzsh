function git_prompt_custom() {
 ref=$(git symbolic-ref HEAD 2> /dev/null) || return
 GIT_STATUS="%{$fg[red]%}<%{$bg[green]%} $(git_prompt_info)%{$bg[green]%}%{$fg[black]%}[%{$fg[red]%}$(git_prompt_short_sha)%{$fg[black]%}]$(git_prompt_status) %{$reset_color%}%{$fg[red]%}>"
 [[ -n $GIT_STATUS ]] && GIT_STATUS=" $GIT_STATUS"
 echo "$ZSH_THEME_GIT_PROMPT_PREFIX$GIT_STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

PROMPT='%n%{$reset_color%}%{$fg[red]%}@%m%{$reset_color%}:[%{$fg[green]%}%~%{$reset_color%}]%u$(git_prompt_custom)%{$fg[red]%} ➜  %{$reset_color%}'
RPROMPT='[%{$fg[red]%}%W %t%{$reset_color%}]'

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=": %{$fg[red]%}✗%{$reset_color%}%{$bg[green]%} "
ZSH_THEME_GIT_PROMPT_CLEAN=": %{$fg[red]%}"

ZSH_THEME_GIT_PROMPT_UNMERGED=" %{$RED%}unmerged"
ZSH_THEME_GIT_PROMPT_DELETED=" %{$RED%}deleted"
ZSH_THEME_GIT_PROMPT_RENAMED=" %{$YELLOW%}renamed"
ZSH_THEME_GIT_PROMPT_MODIFIED=" %{$YELLOW%}modified"
ZSH_THEME_GIT_PROMPT_ADDED=" %{$GREEN%}added"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" %{$WHITE%}untracked"
ZSH_THEME_GIT_PROMPT_AHEAD=" %{$RED%}(!)"