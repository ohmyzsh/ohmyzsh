# author: Adrien Lecharpentier
# release date: 2013-06-25

function prompt_char {
    if [[ $? -ne 0 ]]; then
        echo "%{$fg_bold[red]%}»%{$reset_color%}"
    else
        echo "%{$fg_bold[green]%}»%{$reset_color%}"
    fi
}

function git_show_branch {
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return

    STATUS=${ZSH_THEME_GIT_PROMPT_PREFIX}
    STATUS=$STATUS${ZSH_THEME_GIT_PROMPT_BRANCH_PREFIX}${ref#refs/heads/}${ZSH_THEME_GIT_PROMPT_BRANCH_SUFFIX}
    remote=${$(command git rev-parse --verify ${hook_com[branch]}@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\/}
    if [[ -n ${remote} ]] ; then

        STATUS="$STATUS ${remote#/refs/remote}"

        ahead=$(command git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l | tr -d ' ')
        behind=$(command git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l | tr -d ' ')

        if [ $ahead -gt 0 ]; then
            STATUS="$STATUS $ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_PREFIX$ahead$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_SUFFIX"
        fi
        if [ $behind -gt 0 ]; then
            STATUS="$STATUS $ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_PREFIX$behind$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_SUFFIX"
        fi
        if [ $ahead -eq 0 ] && [ $behind -eq 0 ]; then
            STATUS="$STATUS ="
        fi
    fi

    if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
        STATUS="$STATUS $ZSH_THEME_GIT_PROMPT_STASH"
    fi

    STATUS=$STATUS${ZSH_THEME_GIT_PROMPT_SUFFIX}
    echo $STATUS
}

PROMPT='%{$fg_bold[cyan]%}%n: %{$fg[yellow]%}%04~%{$reset_color%}
$(prompt_char) '
RPROMPT='$(git_prompt_status)%{$reset_color%} $(git_show_branch)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}[%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[blue]%}]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_BRANCH_PREFIX="%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_BRANCH_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_PREFIX="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_SUFFIX="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="↓"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="↑"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="<>"

ZSH_THEME_GIT_PROMPT_STASH="%{$fg[cyan]%}$"

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}*"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}-"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}?"
