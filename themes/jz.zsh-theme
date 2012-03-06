# ------------------------------------------------------------------------------
#          FILE:  jz.zsh-theme
#   DESCRIPTION:  oh-my-zsh theme file.
#        AUTHOR:  Justin Zhu (haoranjzhu@gmail.com)
#       VERSION:  1.0.0
#    SCREENSHOT:
# ------------------------------------------------------------------------------

# Shows background jobs:
#   #jobs  Display
#     0    Nothing
#    1-7   [bg:#jobs] in yellow
#    > 8  [bg:#jobs] in red
#
# Shows suspended jobs:
#   #jobs  Display
#     0    Nothing
#    1-2   [sp:#jobs] in yellow
#    > 2   [bg:#jobs] in red
jobs_precmd_hook() {
    local count=$#jobstates[(R)running*]
     if [[ count -gt 8 ]]; then
       BG_COUNT="%{$fg[red]%}[bg:${count}]%{$reset_color%}"
     elif [[ count -gt 0 ]]; then
       BG_COUNT="%{$fg[yellow]%}[bg:${count}]%{$reset_color%}"
     else
       BG_COUNT=""
     fi

     count=$#jobstates[(R)suspended*]
     if [[ count -gt 2 ]]; then
       SP_COUNT="%{$fg[red]%}[sp:${count}]%{$reset_color%}"
     elif [[ count -gt 0 ]]; then
       SP_COUNT="%{$fg[yellow]%}[sp:${count}]%{$reset_color%}"
     else
       SP_COUNT=""
     fi
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd jobs_precmd_hook

git_prompt_info_status() {
 local git_info=$(git_prompt_info) 
 # git_prompt_status commented out cuz its fucking slow
  [[ -n $git_info ]] && echo "%{$fg[green]%}[${git_info}$(git_prompt_status)%{$fg[green]%}]%{$reset_color%}"
#[[ -n $git_info ]] && echo "%{$fg[green]%}[${git_info}%{$fg[green]%}]%{$reset_color%}"
}

if [[ "$TERM" != "dumb" ]] && [[ "$DISABLE_LS_COLORS" != "true" ]]; then
    PROMPT='%{$fg[blue]%}[%{$fg[red]%}%n%{$FG[242]%}@%{$fg[magenta]%}%m%{$reset_color%}:%{$fg[blue]%}%~]%{$reset_color%}$(git_prompt_info_status)$BG_COUNT$SP_COUNT
%(?.%{$fg_bold[green]%}❯.%{$fg_bold[red]%}❯)%{$reset_color%} '

    ZSH_THEME_GIT_PROMPT_PREFIX=""
    ZSH_THEME_GIT_PROMPT_SUFFIX=""
    ZSH_THEME_GIT_PROMPT_DIRTY=""
    ZSH_THEME_GIT_PROMPT_CLEAN=""

    # display exitcode on the right when >0
    return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

    RPROMPT='${return_code}%{$reset_color%}'

    ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ✚"
    ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} ✹"
    ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖"
    ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ➜"
    ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ═"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ✭"
else
    PROMPT='[%n@%m:%~$(git_prompt_info)]
❯ '

    ZSH_THEME_GIT_PROMPT_PREFIX=" on"
    ZSH_THEME_GIT_PROMPT_SUFFIX=""
    ZSH_THEME_GIT_PROMPT_DIRTY=""
    ZSH_THEME_GIT_PROMPT_CLEAN=""

    # display exitcode on the right when >0
    return_code="%(?..%? ↵)"

    RPROMPT='${return_code}'

    ZSH_THEME_GIT_PROMPT_ADDED=" ✚"
    ZSH_THEME_GIT_PROMPT_MODIFIED=" ✹"
    ZSH_THEME_GIT_PROMPT_DELETED=" ✖"
    ZSH_THEME_GIT_PROMPT_RENAMED=" ➜"
    ZSH_THEME_GIT_PROMPT_UNMERGED=" ═"
    ZSH_THEME_GIT_PROMPT_UNTRACKED=" ✭"
fi
