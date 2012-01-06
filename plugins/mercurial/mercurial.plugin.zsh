## Source : https://bitbucket.org/Josh/mercurial-for-zsh

function chpwd_update_hg_vars() {
    update_current_hg_vars
}

function precmd_update_hg_vars(){
    if [ -n "$__EXECUTED_HG_COMMAND" ]; then
        update_current_hg_vars
        unset __EXECUTED_HG_COMMAND
    fi
}


function preexec_update_hg_vars(){
    case "$1" in
        hg*)
            export __EXECUTED_HG_COMMAND=1
            ;;
    esac
}

function prompt_hg_info(){
    if [ -n "$__CURRENT_HG_BRANCH" ]; then
        local s="["
        s+="$__CURRENT_HG_BRANCH"
        case "$__CURRENT_HG_BRANCH_STATUS" in
            ahead)
            s+=" ↑"
            ;;
            diverged)
            s+=" ↕"
            ;;
            behind)
            s+=" ↓"
            ;;
        esac
        if [ -n "$__CURRENT_HG_BRANCH_IS_DIRTY" ]; then
            s+=" ⚡"
        fi
        s+="] "

        printf " %s%s" "%{${fg[yellow]}%}" $s
    fi
}

function update_current_hg_vars(){
    unset __CURRENT_HG_BRANCH
    unset __CURRENT_HG_BRANCH_STATUS
    unset __CURRENT_HG_BRANCH_IS_DIRTY
    local st="$(hg status 2>/dev/null)"
    local br="$(hg branch 2>/dev/null)"
    if [ -n "$br" ]; then
        local -a arr
        arr=(${(f)br})
        export __CURRENT_HG_BRANCH="$(echo $arr[1])"
    fi
    if [ -n "$st" ]; then
        if echo $st | grep "nothing to commit (working directory clean)" >/dev/null; then
        else
            export __CURRENT_HG_BRANCH_IS_DIRTY='1'
        fi
    fi
}

typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions

preexec_functions+='preexec_update_hg_vars'
precmd_functions+='precmd_update_hg_vars'
chpwd_functions+='chpwd_update_hg_vars'

# Set the prompt.
# PROMPT=$'%{${fg[cyan]}%}%B%~%b$(prompt_hg_info)%{${fg[default]}%} '

# Mercurial
alias hgc='hg commit -v'
alias hgb='hg branch -v'
alias hgba='hg branches'
alias hgco='hg checkout'
alias hgd='hg diff'
alias hged='hg diffmerge'
# pull and update
alias hgl='hg pull -u -v'
alias hgp='hg push -v'
alias hgs='hg status -v'
# this is the 'git commit --amend' equivalent
alias hgca='hg qimport -r tip ; hg qrefresh -e ; hg qfinish tip'
