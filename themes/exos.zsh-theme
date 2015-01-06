autoload -U add-zsh-hook
autoload -Uz vcs_info

zstyle ':vcs_info:*' actionformats \
  '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '

zstyle ':vcs_info:*' formats '%F{2}%F{1}%b%F{2}%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' enable git

add-zsh-hook precmd detect_pdir
add-zsh-hook precmd prompt_vcs
add-zsh-hook precmd prompt_virtualenv
add-zsh-hook precmd prompt_projectname 

presentation () {
    toilet -f future -F metal "$HOST $(date +%H:%m:%S)" 2> /dev/null && {
        w 
    } || {
        echo "This theme requires toilet command, please install" 
    }
}

detect_pdir () {
    pdir=$(git rev-parse --show-toplevel 2> /dev/null )
}

prompt_vcs () {
    vcs_info

    if [ "${vcs_info_msg_0_}" = "" ]; then
        dir_status=""
    elif [[ $(git diff --cached --name-status 2>/dev/null ) != "" ]]; then
        dir_status="%F{1}⬆%f"
    elif [[ $(git diff --name-status 2>/dev/null ) != "" ]]; then
        dir_status="%F{3}⬆%f"
    else
        dir_status="%F{2}✓%f"
    fi

    if [ "${vcs_info_msg_0_}" = ""  ]; then
        cbranch=""
    else
        cbranch="⭠${vcs_info_msg_0_}"
    fi

}

prompt_virtualenv () {
    if [[ -n $VIRTUAL_ENV ]]; then
        ve_status="%F{2} ⌬%f "
    elif [[ -n $pdir ]]; then
        if [[ -d $pdir/virtualenv || -d $pdir/.virtualenv || -f $pdir/requirements.txt ]]; then
            ve_status="%F{1} ⌬%f "
        else
            ve_status=""
        fi
    fi
}

prompt_projectname () {

    pname=" ${cbranch}${dir_status}${ve_status}" 

    if [[ -n $pdir ]]; then

        if [[ -f $pdir/package.json ]]; then
            ppname=$(python2 -c "import json;print json.loads(open('$pdir/package.json', 'r').read())['name']" 2> /dev/null)
        elif [[ -f $pdir/bower.json ]]; then
            ppname=$(python2 -c "import json;print json.loads(open('$pdir/bower.json', 'r').read())['name']" 2> /dev/null)
        else
            ppname=$(basename $pdir)
        fi

        if [[ -n $ppname ]]; then 
            pname=" ⁅${ve_status}${ppname} ${cbranch}${dir_status} ⁆"
        fi
    fi

}

function {
    if [[ -n "$SSH_CLIENT" ]]; then
        PROMPT_HOST=" $HOST ➲ "
    else
        PROMPT_HOST=''
    fi
}

local ret_status="%(?:%{$fg_bold[green]%}⏺:%{$fg_bold[red]%}⏺)"

PROMPT='${ret_status}%{$fg[blue]%}${PROMPT_HOST}${pname}%{$fg_bold[green]%}%p %{$fg_bold[yellow]%}%2~ ▶%{$reset_color%} '
RPROMPT='%F{blue}$(pwd)%(?: :%{$fg_bold[red]%} %? )%F{yellow}[%*]%f'

presentation

#  vim: set ft=zsh ts=4 sw=4 et:
