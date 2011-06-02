# ------------------------------------------------------------------------------
#          FILE:  git-prompt.plugin.zsh
#   DESCRIPTION:  oh-my-zsh git information for your PROMPT.
#        AUTHOR:  Ashley Dev (the.ashley.dev+git-prompt@gmail.com)
#       VERSION:  2.1
#    SCREENSHOT:  http://i.imgur.com/Yw1KG.png
#                 http://i.imgur.com/wx6MU.png
# ------------------------------------------------------------------------------

# USAGE:
#
# Add 'git' to your list of oh-my-zsh plugins (in your .zshrc) otherwise this
# git prompt info will not show up in your prompt.
#
# This simple example shows some of the things you can do with this plugin.
# (See the ashleydev theme for more complex usage.)
# ---------------------- SAMPLE THEME FILE ------------------------
#
#     # this is a simple example PROMPT with only git
#     # info from this plugin in it:
#     PROMPT='$__GIT_PROMPT_INFO# '
# 
#     #GIT_PROMPT_SHORTCIRCUIT='off'
#     
#     # GIT_PROMPT_INFO_FUNC must be set to the
#     # function that defines your prompt info
#     # in order to turn this plugin on.
#     GIT_PROMPT_INFO_FUNC='update__GIT_PROMPT_INFO'
#
#     local __GIT_PROMPT_INFO=''
#     update__GIT_PROMPT_INFO ()
#     {
#         _git_prompt__branch
#         local b=$GIT_PROMPT_BRANCH
#     
#         _git_prompt__dirty_state
#         local w=$GIT_PROMPT_DIRTY_STATE_WORKTREE_DIRTY
#         local i=$GIT_PROMPT_DIRTY_STATE_INDEX_DIRTY
#     
#         # Reset color
#         local R="%{$terminfo[sgr0]%}"
#
#         if [ "$i" = "yes" ]; then
#             i="%{$bold_color$fg[red]%}+$R"
#         else
#             i=""
#         fi
#     
#         if [ -n "$b" ]; then
#             if [ "$w" = 'yes' ]; then
#                 b="%{$fg_no_bold[red]%}$b$R"
#             elif [ "$w" = 'no' ]; then
#                 b="%{$fg_no_bold[green]%}$b$R"
#             fi
#         fi
#     
#         __GIT_PROMPT_INFO="$R($b$i)$R"
#     }
# -----------------------------------------------------------------
#
#


#------------------ git information utils ------------------
# For some of the following functions, I borrowed some from:
#   https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
#

# _git_promt__git_dir accepts 0 or 1 arguments (i.e., location)
# echos the location of .git repo.
# Useful for quickly figuring out if cwd is under a git repo.
_git_promt__git_dir ()
{
    if [ -z "${1-}" ]; then
        if [ -d .git ]; then
            echo .git
        else
            git rev-parse --git-dir 2>/dev/null
        fi
    elif [ -d "$1/.git" ]; then
        echo "$1/.git"
    else
        echo "$1"
    fi
}

# sets GIT_PROMPT_UPSTREAM_STATE
#
# output format:
# A "<" indicates you are behind, ">" indicates you are ahead, "<>"
# indicates you have diverged, "=" indicates no divergence, and "" indicates
# there is no upstream or this feature is turned 'off' (see below).
#
# You can control behaviour by setting GIT_PROMPT_SHOWUPSTREAM to a
# space-separated list of values:
#     off           no output
#     verbose       show number of commits ahead/behind (+/-) upstream instead
#                   of using "<" and ">".
#     legacy        don't use the '--count' option available in recent
#                   versions of git-rev-list
#     git           always compare HEAD to @{upstream}
#     svn           always compare HEAD to your SVN upstream
# By default, _git_prompt__upstream will compare HEAD to your SVN upstream
# if it can find one, or @{upstream} otherwise.  Once you have
# set GIT_PROMPT_SHOWUPSTREAM, you can override it on a
# per-repository basis by setting the prompt.showUpstream config
# variable (i.e. `git config prompt.showUpstream 'verbose legacy'`).
#
# _git_prompt__upstream accepts 0 or 1 arguments.  If an argument is given, it
# must be a string of the form specified above for GIT_PROMPT_SHOWUPSTREAM.
# Setting this argument will override any value set for GIT_PROMPT_SHOWUPSTREAM
# or in the .git/config.
_git_prompt__upstream ()
{
    GIT_PROMPT_UPSTREAM_STATE=''

    if [ "true" != "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]; then
        return
    fi

    local key value
    local svn_remote svn_url_pattern count n
    local upstream=git legacy="" verbose=""
    local p

    # get some config options from git-config
    while read key value; do
        case "$key" in
        prompt.showupstream*)
            GIT_PROMPT_SHOWUPSTREAM="$value"
            ;;
        svn-remote.*.url)
            svn_remote=( "${svn_remote[@]}" $value )
            svn_url_pattern="$svn_url_pattern\\|$value"
            upstream=svn+git # default upstream is SVN if available, else git
            ;;
        esac
    done < <(git config --get-regexp '^(svn-remote\..*\.url|prompt\.showupstream)' 2>/dev/null)

    if [ -n "${1-}" ]; then
        GIT_PROMPT_SHOWUPSTREAM=$1
    fi

    # parse configuration values
    for option in ${GIT_PROMPT_SHOWUPSTREAM}; do
        case "$option" in
        off) return ;;
        git|svn) upstream="$option" ;;
        verbose) verbose=1 ;;
        legacy)  legacy=1  ;;
        esac
    done

    # Find our upstream
    case "$upstream" in
    git)    upstream="@{upstream}" ;;
    svn*)
        # get the upstream from the "git-svn-id: ..." in a commit message
        # (git-svn uses essentially the same procedure internally)
        local svn_upstream=$(git log --first-parent -1 --grep="^git-svn-id: \(${svn_url_pattern#??}\)" 2>/dev/null | awk '/commit / { print $2 }')
        if [[ 0 -ne ${#svn_upstream[@]} ]]; then
            if [[ -z "$svn_upstream" ]]; then
                # default branch name for checkouts with no layout:
                upstream='git-svn'
            else
                upstream=${svn_upstream#/}
            fi
        elif [[ "svn+git" = "$upstream" ]]; then
            upstream="@{upstream}"
        fi
        ;;
    esac

    # Find how many commits we are ahead/behind our upstream
    # produce equivalent output to --count for older versions of git
    local ahead behind
    if git rev-list --left-right "$upstream"...HEAD >/dev/null 2>&1; then
        behind="$(git rev-list --left-right "$upstream"...HEAD 2>/dev/null | grep '^<' | wc -l | tr -d ' ' 2>/dev/null)"
        ahead="$(git rev-list --left-right "$upstream"...HEAD 2>/dev/null | grep '^[^<]' | wc -l | tr -d ' ' 2>/dev/null)"
        count="$behind $ahead"
    fi

    # calculate the result
    if [[ -z "$verbose" ]]; then
        case "$count" in
        "") # no upstream
            p="" ;;
        "0 0") # equal to upstream
            p="=" ;;
        "0 "*) # ahead of upstream
            p=">" ;;
        *" 0") # behind upstream
            p="<" ;;
        *)      # diverged from upstream
            p="<>" ;;
        esac
    else
        case "$count" in
        "") # no upstream
            p="" ;;
        "0 0") # equal to upstream
            p="=" ;;
        "0 "*) # ahead of upstream
            p="+${count#0 }" ;;
        *" 0") # behind upstream
            p="-${count% 0}" ;;
        *)      # diverged from upstream
            p="-${count% *}+${count#* }" ;;
        esac
    fi

    GIT_PROMPT_UPSTREAM_STATE=$p
}

_git_prompt__rebase_info ()
{
    GIT_PROMPT_REBASE_INFO=''

    if [ "true" != "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]; then
        return
    fi
    if [ "$GIT_PROMPT_SHOWREBASEINFO" = 'off' ]; then
        return
    fi
    if [ "$(git config --bool prompt.showRebaseInfo)" = "false" ]; then
        return
    fi

    local r=""
    local g="$(_git_promt__git_dir)"
    if [ -n "$g" ]; then
        if [ -f "$g/rebase-merge/interactive" ]; then
            r="|REBASE-i"
        elif [ -d "$g/rebase-merge" ]; then
            r="|REBASE-m"
        else
            if [ -d "$g/rebase-apply" ]; then
                if [ -f "$g/rebase-apply/rebasing" ]; then
                    r="|REBASE"
                elif [ -f "$g/rebase-apply/applying" ]; then
                    r="|AM"
                else
                    r="|AM/REBASE"
                fi
            elif [ -f "$g/MERGE_HEAD" ]; then
                r="|MERGING"
            elif [ -f "$g/CHERRY_PICK_HEAD" ]; then
                r="|CHERRY-PICKING"
            elif [ -f "$g/BISECT_LOG" ]; then
                r="|BISECTING"
            fi

        fi
    fi

    GIT_PROMPT_REBASE_INFO=$r
}

_git_prompt__branch ()
{
    GIT_PROMPT_BRANCH=''

    if [ "true" != "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]; then
        return
    fi

    if [ "$GIT_PROMPT_SHOWBRANCH" = 'off' ]; then
        return
    fi
    if [ "$(git config --bool prompt.showBranch)" = "false" ]; then
        return
    fi

    local b=""
    local g="$(_git_promt__git_dir)"
    if [ -n "$g" ]; then
        if [ -f "$g/rebase-merge/interactive" ]; then
            b="$(cat "$g/rebase-merge/head-name")"
        elif [ -d "$g/rebase-merge" ]; then
            b="$(cat "$g/rebase-merge/head-name")"
        else
            b="$(git symbolic-ref HEAD 2>/dev/null)" || {

            b="$(
            case "${GIT_PROMPT_DESCRIBE_STYLE-}" in
                (contains)
                    git describe --contains HEAD ;;
                (branch)
                    git describe --contains --all HEAD ;;
                (describe)
                    git describe HEAD ;;
                (* | default)
                    git describe --tags --exact-match HEAD ;;
            esac 2>/dev/null)" ||

                b="$(cut -c1-7 "$g/HEAD" 2>/dev/null)" ||
                b="$b"
            }
        fi
        b=${b##refs/heads/}
        if [ "true" = "$(git rev-parse --is-inside-git-dir 2>/dev/null)" ]; then
            if [ "true" = "$(git rev-parse --is-bare-repository 2>/dev/null)" ]; then
                b="BARE:$b"
            else
                b="GIT_DIR!"
            fi
        fi
    fi

    GIT_PROMPT_BRANCH=$b
}


_git_prompt__stash ()
{
    GIT_PROMPT_STASH_STATE_DIRTY=''

    if [ "true" != "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]; then
        return
    fi

    if [ "$GIT_PROMPT_SHOWSTASHSTATE" = 'off' ]; then
        return
    fi
    if [ "$(git config --bool prompt.showStashState)" = "false" ]; then
        return
    fi

    if git rev-parse --verify refs/stash >/dev/null 2>&1; then
        GIT_PROMPT_STASH_STATE_DIRTY='yes'
    else
        GIT_PROMPT_STASH_STATE_DIRTY='no'
    fi
}


# This is the short-circuit logic:
#
# Set GIT_PROMPT_SHORTCIRCUIT='off' to turn the short-circuit logic off.
#
# Gathering dirty-state info can take a long time on large repositories.  The
# short-circuit logic is engaged by pressing ctrl-c while the prompt is trying
# to gather information about a large repository.  When this happens the
# short-circuit logic will display a warning and turn off the showing of dirty
# state in your git prompt (for the local repo only).
#
# NOTE: To make the short-circuit logic work, the GIT_PROMPT_INFO_FUNC function
# must set a global variable (with your git prompt format), rather than echo it.
#    Correct:
#
#       PROMPT='$__GIT_PROMPT_INFO > '
#
#       # this function sets $__GIT_PROMPT_INFO
#       function update_prompt_func ()
#       {
#           #...
#           __GIT_PROMPT_INFO="$info"
#       }
#       GIT_PROMPT_INFO_FUNC=update_prompt_func
#
#   Incorrect:
#       
#       PROMPT='$(update_prompt_func) > '
#
#       function update_prompt_func ()
#       {
#           #...
#           echo "$info"
#       }
#       GIT_PROMPT_INFO_FUNC=update_prompt_func
#
local _big_repo='init'
__git_prompt_shortcircuit ()
{
    if [[ "$_big_repo" == 'yes' ]]; then
        _big_repo=''
        if [ "$GIT_PROMPT_SHORTCIRCUIT" != 'off' ]; then
            echo "$fg[red]" > /dev/stderr
            echo "${bold_color}SHELL PROMPT$fg_no_bold[red]: Looks like you hit ctrl-c." > /dev/stderr
            echo "${bold_color}SHELL PROMPT$fg_no_bold[red]: So for this repo I'm setting:" > /dev/stderr
            echo "${bold_color}SHELL PROMPT$fg_no_bold[red]:       git config prompt.showDirtyState false" > /dev/stderr
            echo "${bold_color}SHELL PROMPT$fg_no_bold[red]: On big git repos it takes a long time to get info for your prompt." > /dev/stderr
            echo "${bold_color}SHELL PROMPT$fg_no_bold[red]: To revert it, run:" > /dev/stderr
            echo "${bold_color}SHELL PROMPT$fg_no_bold[red]:$reset_color       git config prompt.showDirtyState true" > /dev/stderr
            echo '' > /dev/stderr

            git config prompt.showDirtyState 'false'
            $GIT_PROMPT_INFO_FUNC
        fi
    fi
}
TRAPINT ()
{
    __git_prompt_shortcircuit
    return $(( 128 + $1 ))
}

_git_prompt__dirty_state ()
{
    GIT_PROMPT_DIRTY_STATE_FRESH_REPO=''
    GIT_PROMPT_DIRTY_STATE_INDEX_ADDED=''
    GIT_PROMPT_DIRTY_STATE_INDEX_COPIED=''
    GIT_PROMPT_DIRTY_STATE_INDEX_DELETED=''
    GIT_PROMPT_DIRTY_STATE_INDEX_DIRTY=''
    GIT_PROMPT_DIRTY_STATE_INDEX_MODIFIED=''
    GIT_PROMPT_DIRTY_STATE_INDEX_RENAMED=''
    GIT_PROMPT_DIRTY_STATE_INDEX_UNMERGED=''
    GIT_PROMPT_DIRTY_STATE_WORKTREE_DELETED=''
    GIT_PROMPT_DIRTY_STATE_WORKTREE_DIRTY=''
    GIT_PROMPT_DIRTY_STATE_WORKTREE_MODIFIED=''
    GIT_PROMPT_DIRTY_STATE_WORKTREE_UNTRACKED=''

    if [ "true" != "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]; then
        return
    fi

    local g="$(_git_promt__git_dir)"
    if [ -z "$g" ]; then
        return
    fi
    if [ "$GIT_PROMPT_SHOWDIRTYSTATE" = 'off' ]; then
        return
    fi
    if [ "$(git config --bool prompt.showDirtyState)" = "false" ]; then
        return
    fi

    GIT_PROMPT_DIRTY_STATE_FRESH_REPO='no'
    GIT_PROMPT_DIRTY_STATE_INDEX_ADDED='no'
    GIT_PROMPT_DIRTY_STATE_INDEX_COPIED='no'
    GIT_PROMPT_DIRTY_STATE_INDEX_DELETED='no'
    GIT_PROMPT_DIRTY_STATE_INDEX_DIRTY='no'
    GIT_PROMPT_DIRTY_STATE_INDEX_MODIFIED='no'
    GIT_PROMPT_DIRTY_STATE_INDEX_RENAMED='no'
    GIT_PROMPT_DIRTY_STATE_INDEX_UNMERGED='no'
    GIT_PROMPT_DIRTY_STATE_WORKTREE_DELETED='no'
    GIT_PROMPT_DIRTY_STATE_WORKTREE_DIRTY='no'
    GIT_PROMPT_DIRTY_STATE_WORKTREE_MODIFIED='no'
    GIT_PROMPT_DIRTY_STATE_WORKTREE_UNTRACKED='no'

    if git rev-parse --quiet --verify HEAD >/dev/null; then
    else
        GIT_PROMPT_DIRTY_STATE_FRESH_REPO='yes'
    fi

    _big_repo='yes'
    local line
    while IFS=$'\n' read line; do
        if [[ "$line" = M* ]]; then
            GIT_PROMPT_DIRTY_STATE_INDEX_MODIFIED='yes'
            GIT_PROMPT_DIRTY_STATE_INDEX_DIRTY='yes'
        fi
        if [[ "$line" = A* ]]; then
            GIT_PROMPT_DIRTY_STATE_INDEX_ADDED='yes'
            GIT_PROMPT_DIRTY_STATE_INDEX_DIRTY='yes'
        fi
        if [[ "$line" = R* ]]; then
            GIT_PROMPT_DIRTY_STATE_INDEX_RENAMED='yes'
            GIT_PROMPT_DIRTY_STATE_INDEX_DIRTY='yes'
        fi
        if [[ "$line" = C* ]]; then
            GIT_PROMPT_DIRTY_STATE_INDEX_COPIED='yes'
            GIT_PROMPT_DIRTY_STATE_INDEX_DIRTY='yes'
        fi
        if [[ "$line" = D* ]]; then
            GIT_PROMPT_DIRTY_STATE_INDEX_DELETED='yes'
            GIT_PROMPT_DIRTY_STATE_INDEX_DIRTY='yes'
        fi

        if [[ "$line" = \?\?* ]]; then
            GIT_PROMPT_DIRTY_STATE_WORKTREE_UNTRACKED='yes'
        fi
        if [[ "$line" = ?M* ]]; then
            GIT_PROMPT_DIRTY_STATE_WORKTREE_MODIFIED='yes'
            GIT_PROMPT_DIRTY_STATE_WORKTREE_DIRTY='yes'
        fi
        if [[ "$line" = ?D* ]]; then
            GIT_PROMPT_DIRTY_STATE_WORKTREE_DELETED='yes'
            GIT_PROMPT_DIRTY_STATE_WORKTREE_DIRTY='yes'
        fi

        if [[ "$line" = UU* ]]; then
            GIT_PROMPT_DIRTY_STATE_INDEX_UNMERGED='yes'
            GIT_PROMPT_DIRTY_STATE_INDEX_DIRTY='yes'
        fi
    done < <(git status --porcelain 2> /dev/null)
    _big_repo=''
}

#------------------ Fast Prompt ------------------
# This section sets up some functions that get called infrequently as possible
# and therefore don't slow your prompt down as you are using zsh.
#
# I borrowed from: http://sebastiancelis.com/2009/nov/16/zsh-prompt-git-users/

# Enable auto-execution of functions.
typeset -Uga preexec_functions
typeset -Uga precmd_functions
typeset -Uga chpwd_functions
typeset -Uga periodic_functions

# Append git functions needed for prompt.
preexec_functions+='_git_prompt__preexec_update_git_vars'
precmd_functions+='_git_prompt__precmd_update_git_vars'
chpwd_functions+="_git_prompt_info"
PERIOD=15
periodic_functions+="_git_prompt_info"

_git_prompt_info () { $GIT_PROMPT_INFO_FUNC }
_git_prompt_info

_git_prompt__precmd_update_git_vars()
{
    if [[ $ZSH_VERSION = *\ 4.2* ]]; then
        # some older versions of zsh don't have periodic_functions, so do the
        # slow path if that's the case:
        $GIT_PROMPT_INFO_FUNC

    elif [ -n "$__EXECUTED_GIT_COMMAND" ]; then
        $GIT_PROMPT_INFO_FUNC
        unset __EXECUTED_GIT_COMMAND
    fi
}
_git_prompt__preexec_update_git_vars ()
{
    case "$1" in
        $EDITOR*)   __EXECUTED_GIT_COMMAND=1 ;;
        g*)         __EXECUTED_GIT_COMMAND=1 ;;
        rm*)        __EXECUTED_GIT_COMMAND=1 ;;
        touch*)     __EXECUTED_GIT_COMMAND=1 ;;
        mkdir*)     __EXECUTED_GIT_COMMAND=1 ;;
    esac
}

#--------------------------------------------------
