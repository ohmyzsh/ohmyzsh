#-------------------- PROMPT definition: ----------------------
# Set the prompt.

# 'R'eset formating
local R="%{$terminfo[sgr0]%}"

# special colors for privileged users (root)
local user_="%(!.%{$fg_bold[yellow]$bg[red]%}.%{$fg_bold[cyan]%})%n$R"
local host_="%(!.%{$fg[red]%}.%{$fg_bold[blue]%})%m$R"
local path_="%(!.%{$fg_bold[white]%}.%{$fg_bold[white]%})%~$R"
local jobs_="%(1j.%{$fg[blue]%}%j$R.)"

PROMPT='$user_$host_$path_ $(git_prompt_info)$jobs_# '

local date_format_="%D{%a %b %d}, %*"
local date_="%{$fg[green]%}[$date_format_]"
local return_code_="%(?..%{$fg[red]%}%? ↵ )"

RPROMPT='$return_code_$R$date_$R'

# use the vi-mode oh-my-zsh plugin to get this:
MODE_INDICATOR="%{$fg_bold[cyan]%}-- CMD MODE -- $R"

#-----------------------------------------------------
# git prompt info:

local GIT_PROMPT_SHOWUPSTREAM="verbose"

# git_prompt_info colors ('_C' for color):
local _Cerror_="%{$fg[yellow]%}"            # bad (empty) .git/ directory
local _Cb_new_repo_="%{$fg_bold[default]%}" # branch color of new repo
local _Cb_clean_="%{$fg_no_bold[green]%}"   # branch color when clean
local _Cb_dirty_="%{$fg_no_bold[red]%}"     # branch color when dirty
local _Cr_="%{$bold_color$fg[yellow]%}"     # rebase info
local _Ci_="%{$bold_color$fg[red]%}"        # index info
local _Cu_clean_=""                         # untracked files state when clean
local _Cu_dirty_="%{$fg_bold[red]%}"        # untracked files state when dirty
local _Cp_="%{${fg[cyan]}%}"                # upstream info
local _Cs_=""                               # stash state

# will set __GIT_PROMPT_INFO
__git_prompt_format_and_color_with_shortcircuit ()
{
    local g="$(__git_dir)"
    if [ -z "$g" ]; then
        __GIT_PROMPT_INFO=''
        return
    fi

    local w=""  # workspace state
    local s=""  # stash state
    local i=""  # index state
    local u=""  # untracked files state
    local p=""  # u'p'stream state
    local b="$(__git_branch)"      # branch
    local r="$(__git_rebase_info)" # rebase info

    if [ "true" = "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]; then
        if [ "$GIT_PROMPT_SHOWDIRTYSTATE" != 'off' ]; then
            if [ "$(git config --bool prompt.showDirtyState)" != "false" ]; then
                # This is the short circuit logic:
                # The following 3 functions can take a long time on big
                # repositories, so check to see if ctrl-c is entered by
                # setting _big_repo for the duration of these functions:
                # (Then check for _big_repo in TRAPINT().)
                _big_repo='yes'
                i="$(__git_dirty_state_staged)"
                w="$(__git_dirty_state_unstaged)"
                u="$(__git_dirty_state_untracked_files)"
                _big_repo=''
            fi
        fi
        s="$(__git_stash_state)"
        p="$(__git_upstream)"
    fi

    if [ -z "$b$i$w$u" ]; then
        if [ -n "$g" ]; then
            __GIT_PROMPT_INFO="$R$_Cerror_(Error: bad ./$g dir)$R"
            return
        fi
    fi

    if [ "$s" = 'dirty' ]; then
        s="$_Cs_\$$R"
    else
        s=""
    fi

    if [ -n "$p" ]; then
        p="$_Cp_$p$R"
    fi

    if [ "$i" = "dirty" ]; then
        i="$_Ci_+$R"
    else
        i=""
    fi

    if [ -n "$b" ]; then
        if [ "$w" = "fresh" ]; then
            # this is a fresh repo, nothing here...
            b="$_Cb_new_repo_$b$R"
        elif [ "$w" = 'dirty' ]; then
            b="$_Cb_dirty_$b$R"
        elif [ "$w" = 'clean' ]; then
            b="$_Cb_clean_$b$R"
        fi
    fi

    if [ -n "$r" ]; then
        r="$_Cr_$r$R"
    fi

    local _prompt="$b$r$s$i$p"

    # add ( ) around _prompt:
    if [ "$u" = "dirty" ]; then
        _prompt="$_Cu_dirty_($_prompt$_Cu_dirty_)"
    elif [ "$u" = "clean" ]; then
        _prompt="$_Cu_clean_($_prompt$_Cu_clean_)"
    else
        _prompt="($_prompt)"
    fi

    # NOTE: This function must set __GIT_PROMPT_INFO to return it's value,
    # rather than echo'ing it for the caller to call it as:
    # __GIT_PROMPT_INFO=$(__git_prompt_format_and_color_with_shortcircuit)
    # because if we were to call this function in $(...), then the short-circuit
    # would not work because __git_prompt_format_and_color_with_shortcircuit
    # would be executed in a sub shell and setting _big_repo='yes' would not set
    # the same _big_repo as is in scope in TRAPINT().
    __GIT_PROMPT_INFO="$R$_prompt$R"
}

local _big_repo='init'
TRAPINT()
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
            __git_prompt_format_and_color_with_shortcircuit
        fi
    fi
    return $(( 128 + $1 ))
}

#------------------ setting git_prompt_info (FAST) ------------------
# To get a fast prompt I borrowed from:
#   http://sebastiancelis.com/2009/nov/16/zsh-prompt-git-users/
#
# This section sets up some functions that get called infrequently as possible
# and therefore don't slow your prompt down as you are using zsh.

git_prompt_info ()
{
    # some older versions of zsh don't have periodic_functions, so do the slow
    # path if that's the case:
    [[ $ZSH_VERSION = *\ 4.2* ]] && update_current_git_vars

    echo $__GIT_PROMPT_INFO
}

update_current_git_vars()
{
    # sets __GIT_PROMPT_INFO:
    __git_prompt_format_and_color_with_shortcircuit
}

precmd_update_git_vars()
{
    if [ -n "$__EXECUTED_GIT_COMMAND" ]; then
        update_current_git_vars
        unset __EXECUTED_GIT_COMMAND
    fi
}

preexec_update_git_vars ()
{
    case "$1" in
        vim*)
        __EXECUTED_GIT_COMMAND=1
        ;;
        g*)
        __EXECUTED_GIT_COMMAND=1
        ;;
        rm*)
        __EXECUTED_GIT_COMMAND=1
        ;;
        touch*)
        __EXECUTED_GIT_COMMAND=1
        ;;
        mkdir*)
        __EXECUTED_GIT_COMMAND=1
        ;;
#         f)
#         __EXECUTED_GIT_COMMAND=1
#         ;;
#         fg)
#         __EXECUTED_GIT_COMMAND=1
#         ;;
    esac
}


# Enable auto-execution of functions.
typeset -Uga preexec_functions
typeset -Uga precmd_functions
typeset -Uga chpwd_functions
typeset -Uga periodic_functions

# Append git functions needed for prompt.
preexec_functions+='preexec_update_git_vars'
precmd_functions+='precmd_update_git_vars'
chpwd_functions+='update_current_git_vars'
PERIOD=15
periodic_functions+='update_current_git_vars'

#------------------ git information utils ------------------
# To pull information out of git, I borrowed from:
#   https://github.com/git/git/blob/master/contrib/completion/git-completion.bash

# __git_dir accepts 0 or 1 arguments (i.e., location)
# echos location of .git repo
__git_dir ()
{
    if [ -z "${1-}" ]; then
        if [ -n "${__git_dir-}" ]; then
            echo "$__git_dir"
        elif [ -d .git ]; then
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

# echos divergence from upstream
#
# Usage:
#   
#   divergence="$(__git_upstream)"
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
# By default, __git_upstream will compare HEAD to your SVN upstream
# if it can find one, or @{upstream} otherwise.  Once you have
# set GIT_PROMPT_SHOWUPSTREAM, you can override it on a
# per-repository basis by setting the prompt.showUpstream config
# variable (i.e. `git config prompt.showUpstream 'verbose legacy'`).
#
# __git_upstream accepts 0 or 1 arguments.  If an argument is given, it must be
# a string of the form specified above for GIT_PROMPT_SHOWUPSTREAM.  Setting
# this argument will override any value set for GIT_PROMPT_SHOWUPSTREAM or in
# the .git/config.
__git_upstream ()
{
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
    echo $p
}

__git_rebase_info ()
{
    if [ "$GIT_PROMPT_SHOWREBASEINFO" != 'off' ]; then
        if [ "$(git config --bool prompt.showRebaseInfo)" != "false" ]; then

            local r=""
            local g="$(__git_dir)"
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
            echo $r

        fi
    fi
}

__git_branch ()
{
    if [ "$GIT_PROMPT_SHOWBRANCH" != 'off' ]; then
        if [ "$(git config --bool prompt.showBranch)" != "false" ]; then

            local b=""
            local g="$(__git_dir)"
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
            echo $b

        fi
    fi
}

__git_dirty_state_untracked_files ()
{
    if [ "$GIT_PROMPT_SHOWUNTRACKEDFILES" != 'off' ]; then
        if [ "$(git config --bool prompt.showUntrackedFiles)" != "false" ]; then
            if [ -n "$(git ls-files --others --exclude-standard)" ]; then
                echo ${GIT_PROMPT_SHOWUNTRACKEDFILES_DIRTY_MARK-dirty}
            else
                echo ${GIT_PROMPT_SHOWUNTRACKEDFILES_CLEAN_MARK-clean}
            fi
            return
        fi
    fi
    echo ${GIT_PROMPT_FEATURE_OFF-feature_off}
}


__git_stash_state ()
{
    if [ "$GIT_PROMPT_SHOWSTASHSTATE" != 'off' ]; then
        if [ "$(git config --bool prompt.showStashState)" != "false" ]; then
            if git rev-parse --verify refs/stash >/dev/null 2>&1; then
                echo ${GIT_PROMPT_SHOWSTASHSTATE_DIRTY_MARK-dirty}
            else
                echo ${GIT_PROMPT_SHOWSTASHSTATE_CLEAN_MARK-clean}
            fi
            return
        fi
    fi
    echo ${GIT_PROMPT_FEATURE_OFF-feature_off}
}


__git_dirty_state_unstaged ()
{
    if [ "$GIT_PROMPT_DIRTYSTATEUNSTAGED" != 'off' ]; then
        if [ "$(git config --bool prompt.showDirtyStateUnstaged)" != "false" ]; then
            if git rev-parse --quiet --verify HEAD >/dev/null; then
                if git diff --no-ext-diff --quiet --exit-code; then
                    echo ${GIT_PROMPT_DIRTYSTATEUNSTAGED_CLEAN_MARK-clean}
                else
                    echo ${GIT_PROMPT_DIRTYSTATEUNSTAGED_DIRTY_MARK-dirty}
                fi
            else
                echo ${GIT_PROMPT_FRESH_REPO-fresh}
            fi
            return
        fi
    fi
    echo ${GIT_PROMPT_FEATURE_OFF-feature_off}
}

__git_dirty_state_staged ()
{
    if [ "$GIT_PROMPT_DIRTYSTATESTAGED" != 'off' ]; then
        if [ "$(git config --bool prompt.showDirtyStateStaged)" != "false" ]; then
            if git rev-parse --quiet --verify HEAD >/dev/null; then
                # if this isn't a fresh repo:
                if git diff-index --cached --quiet HEAD --; then
                    echo ${GIT_PROMPT_DIRTYSTATESTAGED_CLEAN_MARK-clean}
                else
                    echo ${GIT_PROMPT_DIRTYSTATESTAGED_DIRTY_MARK-dirty}
                fi
            else
                # else take the slower route
                local num_index_files="$(git status --porcelain | egrep '^[MADRCU]' | wc -l | tr -d ' ')"
                if [ $num_index_files = 0 ]; then
                    echo ${GIT_PROMPT_DIRTYSTATESTAGED_CLEAN_MARK-clean}
                else
                    echo ${GIT_PROMPT_DIRTYSTATESTAGED_DIRTY_MARK-dirty}
                fi
            fi
            return
        fi
    fi
    echo ${GIT_PROMPT_FEATURE_OFF-feature_off}
}
