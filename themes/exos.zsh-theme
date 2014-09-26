autoload -U add-zsh-hook
autoload -Uz vcs_info

zstyle ':vcs_info:*' actionformats \
  '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '

zstyle ':vcs_info:*' formats '%F{2}%s%F{7}:%F{2}(%F{1}%b%F{2})%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' enable git

add-zsh-hook precmd prompt_vcs
add-zsh-hook precmd prompt_virtualenv

prompt_vcs () {
    vcs_info

    if [ "${vcs_info_msg_0_}" = "" ]; then
        dir_status="%F{2}→%f"
    elif [[ $(git diff --cached --name-status 2>/dev/null ) != "" ]]; then
        dir_status="%F{1}💾%f"
    elif [[ $(git diff --name-status 2>/dev/null ) != "" ]]; then
        dir_status="%F{3}💾%f"
    else
        dir_status="%F{2}✓▶%f"
    fi
}

prompt_virtualenv () {
    if [[ -n $VIRTUAL_ENV ]]; then
        ve_status="%F{2}⌬%f "
    else
        if [[ -d ./virtualenv || -d ./.virtualenv ]]; then
            ve_status="%F{1}⌬%f "
        else
            ve_status=""
        fi
    fi
}

function {
    if [[ -n "$SSH_CLIENT" ]]; then
        PROMPT_HOST=" ($HOST)"
    else
        PROMPT_HOST=''
    fi
}

local ret_status="%(?:%{$fg_bold[green]%}⌨ :%{$fg_bold[red]%}%S↑%s%?)"

PROMPT='${ret_status}%{$fg[blue]%}${PROMPT_HOST}%{$fg_bold[green]%}%p %{$fg_bold[yellow]%}%2~ ${vcs_info_msg_0_}${ve_status}${dir_status}%{$reset_color%} '
RPROMPT='%F{blue}$(pwd) %F{yellow}[%*]%f'

#  vim: set ft=zsh ts=4 sw=4 et:
