autoload -U add-zsh-hook
autoload -Uz vcs_info

zstyle ':vcs_info:*' check-for-changes true # Can be slow on big repos.
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' unstagedstr '%F{red}'
zstyle ':vcs_info:*' stagedstr '%F{yellow}'
zstyle ':vcs_info:*' hgrevformat "%r"
zstyle ':vcs_info:*' actionformats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f %F{green}%c%u'
zstyle ':vcs_info:*' formats \
    '%F{2}%s%F{7}:%F{2}(%F{1}%b%F{2})%f %F{green}%c%u'
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' enable git svn hg bzr


add-zsh-hook precmd prompt_ycros_precmd

prompt_ycros_precmd () {
    vcs_info

    if [ "${vcs_info_msg_0_}" = "" ]; then
        dir_status="→%f"
    else
        dir_status="▶%f"
    fi
}

local ret_status="%(?:%{$fg_bold[green]%}Ξ:%{$fg_bold[red]%}%S↑%s%?)"

PROMPT='${ret_status}%{$fg_bold[green]%}%p ${SSH_TTY:+[%n@%m] }%{$fg_bold[yellow]%}%2~ ${vcs_info_msg_0_}${dir_status}%{$reset_color%} '

#  vim: set ft=zsh ts=4 sw=4 et:
