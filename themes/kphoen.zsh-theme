# ------------------------------------------------------------------------------
#          FILE:  kphoen.zsh-theme
#   DESCRIPTION:  oh-my-zsh theme file.
#        AUTHOR:  Kévin Gomez (geek63@gmail.com)
#       VERSION:  1.0.0
#    SCREENSHOT:
# ------------------------------------------------------------------------------

job_bg() {
  local JC=$(jobs -r | grep running |  wc -l)
  if [[ JC -gt 10 ]]; then
    echo "%{$fg[red]%}[bg:${JC}]%{$reset_color%}"
  elif [[ JC -gt 0 ]]; then
    echo "%{$fg[yellow]%}[bg:${JC}]%{$reset_color%}"
  fi
}

job_sp() {
  local JC=$(jobs -s | grep suspended | wc -l)
  if [[ JC -gt 2 ]]; then
    echo "%{$fg[red]%}[sp:${JC}]%{$reset_color%}"
  elif [[ JC -gt 0 ]]; then
    echo "%{$fg[yellow]%}[sp:${JC}]%{$reset_color%}"
  fi
}

GRAY_COLOR=$FG[242]

if [[ "$TERM" != "dumb" ]] && [[ "$DISABLE_LS_COLORS" != "true" ]]; then
    PROMPT='%{$fg[blue]%}[%{$fg[red]%}%n%{$GRAY_COLOR%}@%{$fg[magenta]%}%m%{$reset_color%}:%{$fg[blue]%}%~]%{$reset_color%}$(git_prompt_info)$(job_bg)$(job_sp)
%(!.%{$fg_bold[red]%}#.%{$fg_bold[green]%}❯)%{$reset_color%} '



    ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}["
    ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_DIRTY=""
    ZSH_THEME_GIT_PROMPT_CLEAN=""

    # display exitcode on the right when >0
    return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

    RPROMPT='${return_code}$(git_prompt_status)%{$reset_color%}'

    ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ✚"
    ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} ✹"
    ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖"
    ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ➜"
    ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ═"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ✭"
else
    PROMPT='[%n@%m:%~$(git_prompt_info)]
%# '

    ZSH_THEME_GIT_PROMPT_PREFIX=" on"
    ZSH_THEME_GIT_PROMPT_SUFFIX=""
    ZSH_THEME_GIT_PROMPT_DIRTY=""
    ZSH_THEME_GIT_PROMPT_CLEAN=""

    # display exitcode on the right when >0
    return_code="%(?..%? ↵)"

    RPROMPT='${return_code}$(git_prompt_status)'

    ZSH_THEME_GIT_PROMPT_ADDED=" ✚"
    ZSH_THEME_GIT_PROMPT_MODIFIED=" ✹"
    ZSH_THEME_GIT_PROMPT_DELETED=" ✖"
    ZSH_THEME_GIT_PROMPT_RENAMED=" ➜"
    ZSH_THEME_GIT_PROMPT_UNMERGED=" ═"
    ZSH_THEME_GIT_PROMPT_UNTRACKED=" ✭"
fi
