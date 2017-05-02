function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# Checks if working tree is dirty
parse_git_dirty() {
  if [[ -n $(git status -s 2> /dev/null) ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}
#PROMPT='%{$fg_bold[red]%}➜ %{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
# If I am using vi keys, I want to know what mode I'm currently using.
# zle-keymap-select is executed every time KEYMAP changes.
# From http://zshwiki.org/home/examples/zlewidgets
function zle-line-init zle-keymap-select {
  if [[ ${KEYMAP} = vicmd ]] ; then
    VIPROMPT="<->" 
    print -Pn "\033]50;CursorShape=0\x7"
  else
    VIPROMPT="-->"
    print -Pn "\033]50;CursorShape=1\x7"
  fi

    #VIMODE="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/}"
#    RPS2=$RPS1
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
setprompt () {
# Finally, let's set the prompt
    USRPROMPT="$(print '%{\e[38;5;32m%}%n%{\e[0m%}@%{\e[38;5;46m%}%m%{\e[0m%} ')"
    PROMPT="$(print '${VIPROMPT} ')"
    RPROMPT="$(print '%{$fg[blue]%}$(git_prompt_info)%{$fg[blue]%}%~%{$reset_color%}')"
    # Of course we need a matching continuation prompt
    PROMPT2=' ->%{$reset_color%}   '
}

setprompt

precmd () { 

    VIPROMPT="-->"
    CURSORSHAPE="\033]50;CursorShape=0\x7"
# set a simple variable to show when in screen
    if [[ -n "${WINDOW}" ]]; then
        PR_SCREEN=" S:${WINDOW}"
    else
        PR_SCREEN=""
    fi
# check if jobs are executing
    if [[ $(jobs | wc -l ) -gt 0 ]]; then
        PR_JOBS=" J:%j"
    else
      PR_JOBS=""
    fi

   print -rP '${PR_BOLD_RED}<${PR_RED}<${PR_BOLD_BLACK}< ${USRPROMPT}${PR_RED}$(parse_git_dirty) ${PR_BOLD_BLACK}%*${PR_BOLD_RED}%(?.. E:%?)%{$fg[blue]%}${PR_SCREEN}${PR_JOBS}'}

ZSH_THEME_GIT_PROMPT_PREFIX="(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[blue]%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}?%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[red]%}!%{$reset_color%}"

LSCOLORS='exgxfxfxcxdxdxhbadbxbx';
export LSCOLORS
