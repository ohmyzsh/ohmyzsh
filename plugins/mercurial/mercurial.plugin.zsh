## Source : https://bitbucket.org/Josh/mercurial-for-zsh

function prompt_hg_info(){
    __CURRENT_DIR_IS_REPO=$(hg summary 2> /dev/null) || return

    if [ -n "$__CURRENT_DIR_IS_REPO" ]; then
        update_current_hg_vars
    fi

    if [ -n "$__CURRENT_HG_BRANCH" ]; then
        local s="$__CURRENT_HG_BRANCH"
        case "$__CURRENT_HG_BRANCH_STATUS" in
            ahead)
            d="↑"
            ;;
            diverged)
            d="↕"
            ;;
            behind)
            d="↓"
            ;;
        esac
        if [ -n "$__CURRENT_HG_BRANCH_IS_DIRTY" ]; then
            d="⚡"
        fi

        printf "%s[%s %s%s%s] " "%{${fg[yellow]}%}" $s "%{${fg[red]}%}" $d "%{${fg[yellow]}%}"
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
