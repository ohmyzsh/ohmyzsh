#-------------------- PROMPT definition: ----------------------
# Set the prompt.

# 'R'eset formats
local R="%{$terminfo[sgr0]%}"

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


# special colors for privileged users (root)
local jobs_="%{$fg[blue]%}%(1j.%j.)"
local user_="%(!.%{$fg_bold[yellow]$bg[red]%}.%{$fg_bold[cyan]%})%n"
local host_="%(!.%{$fg[red]%}.%{$fg_bold[blue]%})%m"
local path_="%(!.%{$fg_bold[white]%}.%{$fg_bold[white]%})%~"

PROMPT='$user_$R$host_$R$path_$R $(git_prompt_info)$R$jobs_$R# '

local date_format_="%D{%a %b %d}, %*"
local date_="%{$fg[green]%}[$date_format_]"
local return_code_="%(?..%{$fg[red]%}%? ↵ )"

# use the vi-mode oh-my-zsh plugin to get this:
MODE_INDICATOR="%{$fg_bold[cyan]%}-- CMD MODE -- $R"

RPROMPT='$return_code_$R$date_$R'

#------------------ setting git_prompt_info (FAST) ------------------
# To get a fast prompt I borrowed from:
#   http://sebastiancelis.com/2009/nov/16/zsh-prompt-git-users/
#
# This section sets up some functions that get called infrequently as possible
# and therefore don't slow your prompt down as you are using zsh.

export GIT_PS1_SHOWUPSTREAM="verbose"
export GIT_PS1_SHOWSTASHSTATE='yes'
export GIT_PS1_SHOWDIRTYSTATE='yes'
export GIT_PS1_SHOWUNTRACKEDFILES='yes'

function git_prompt_info ()
{
    # some older versions of zsh don't have periodic_functions, so do the slow
    # path if that's the case:
    [[ $ZSH_VERSION = *\ 4.2* ]] && update_current_git_vars
    echo "$__GIT_PROMPT_INFO"
}

function update_current_git_vars()
{
    __GIT_PROMPT_INFO="$(__git_prompt_format_and_color_with_shortcircuit)"
}

function precmd_update_git_vars()
{
    if [ -n "$__EXECUTED_GIT_COMMAND" ]; then
        update_current_git_vars
        unset __EXECUTED_GIT_COMMAND
    fi
}

function preexec_update_git_vars ()
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
typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions
typeset -ga periodic_functions

# Append git functions needed for prompt.
preexec_functions+='preexec_update_git_vars'
precmd_functions+='precmd_update_git_vars'
chpwd_functions+='update_current_git_vars'
PERIOD=15
periodic_functions+='update_current_git_vars'



#------------------ git information utils ------------------
# To pull information out of git, I borrowed from:
#   https://github.com/git/git/blob/master/contrib/completion/git-completion.bash

# __gitdir accepts 0 or 1 arguments (i.e., location)
# returns location of .git repo
__gitdir ()
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
# used by GIT_PS1_SHOWUPSTREAM
__git_show_upstream ()
{
    local key value
    local svn_remote svn_url_pattern count n
    local upstream=git legacy="" verbose=""
    local p

    # get some config options from git-config
    while read key value; do
        case "$key" in
        prompt.showUpstream)
            GIT_PS1_SHOWUPSTREAM="$value"
            if [[ -z "${GIT_PS1_SHOWUPSTREAM}" ]]; then
                p=""
                return
            fi
            ;;
        svn-remote.*.url)
            svn_remote=( "${svn_remote[@]}" $value )
            svn_url_pattern="$svn_url_pattern\\|$value"
            upstream=svn+git # default upstream is SVN if available, else git
            ;;
        esac
    done < <(git config --get-regexp '^(svn-remote\..*\.url|prompt\.showUpstream)$' 2>/dev/null)

    # parse configuration values
    for option in ${GIT_PS1_SHOWUPSTREAM}; do
        case "$option" in
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
        count="$behind  $ahead"
    fi

    # calculate the result
    if [[ -z "$verbose" ]]; then
        case "$count" in
        "") # no upstream
            p="" ;;
        "0  0") # equal to upstream
            p="=" ;;
        "0  "*) # ahead of upstream
            p=">" ;;
        *"  0") # behind upstream
            p="<" ;;
        *)      # diverged from upstream
            p="<>" ;;
        esac
    else
        case "$count" in
        "") # no upstream
            p="" ;;
        "0  0") # equal to upstream
            p="=" ;;
        "0  "*) # ahead of upstream
            p="+${count#0  }" ;;
        *"  0") # behind upstream
            p="-${count%  0}" ;;
        *)      # diverged from upstream
            p="-${count%  *}+${count#*  }" ;;
        esac
    fi
    echo $p
}

__git_show_rebase_info ()
{
    local r=""
    local g="$(__gitdir)"
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
}

# stores the branch name in $b
__git_show_branch ()
{
    local b=""
    local g="$(__gitdir)"
    if [ -n "$g" ]; then
        if [ -f "$g/rebase-merge/interactive" ]; then
            b="$(cat "$g/rebase-merge/head-name")"
        elif [ -d "$g/rebase-merge" ]; then
            b="$(cat "$g/rebase-merge/head-name")"
        else
            b="$(git symbolic-ref HEAD 2>/dev/null)" || {

                b="$(
                case "${GIT_PS1_DESCRIBE_STYLE-}" in
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
}

__git_show_untracked_files ()
{
    if [ -n "$(git ls-files --others --exclude-standard)" ]; then
        echo "%"
    fi
}

__git_show_stash_state ()
{
    git rev-parse --verify refs/stash >/dev/null 2>&1 && echo "$"
}

__git_show_dirty_state_unstaged ()
{
    git diff --no-ext-diff --quiet --exit-code || echo "*"
}

__git_show_dirty_state_staged ()
{
    if git rev-parse --quiet --verify HEAD >/dev/null; then
        git diff-index --cached --quiet HEAD -- || echo "+"
    else
        echo "#"
    fi
}

#-----------------------------------------------------
__git_prompt_format_and_color_with_shortcircuit ()
{
    local g="$(__gitdir)"
    if [ -n "$g" ]; then
        local w=""  # workspace state
        local s=""  # stash state
        local i=""  # index state
        local si="" # stash + index state
        local u=""  # untracked files state
        local p=""  # u'p'stream state
        local b="$(__git_show_branch)"      # branch
        local r="$(__git_show_rebase_info)" # rebase info
        if [ -n "$r" ]; then
            r="$_Crebase_$r$R"
        fi


        if [ "true" = "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]; then
            if [ -n "${GIT_PS1_SHOWDIRTYSTATE-}" ]; then
                if [ "$(git config --bool prompt.showDirtyState)" != "false" ]; then

                    if [ -z "$(eval print \$_big_repo$$)" ]; then
                        # This is the short circuit logic:
                        # The following 3 functions can take a long time on big
                        # repositories, so check to see if ctrl-c is entered by
                        # setting _big_repo$$ for the duration of these functions:
                        eval _big_repo$$='yes'

                        i="$(__git_show_dirty_state_staged)"
                        if [ "$i" = "+" ]; then
                            i="$_Ci_$i$R"
                        fi

                        w="$(__git_show_dirty_state_unstaged)"
                        if [ -n "$b" ]; then
                            if [ "$i" = "#" ]; then
                                # this is a fresh repo, nothing here...
                                b="$_Cb_new_repo_$b$R"
                                i=''
                            elif [ -n "$w" ]; then
                                b="$_Cb_dirty_$b$R"
                            else
                                b="$_Cb_clean_$b$R"
                            fi
                        fi

                        if [ -n "${GIT_PS1_SHOWUNTRACKEDFILES-}" ]; then
                            u="$(__git_show_untracked_files)"
                        fi
                    else
                        echo "$fg[red]"
                        echo "${bold_color}SHELL PROMPT$fg_no_bold[red]: Looks like you hit ctrl-c."
                        echo "${bold_color}SHELL PROMPT$fg_no_bold[red]: On big repositories it takes a long time to get git info for your prompt."
                        echo "${bold_color}SHELL PROMPT$fg_no_bold[red]: So I'm setting \`git config prompt.showDirtyState false\` on this repository because you hit ctrl-c."
                        echo "${bold_color}SHELL PROMPT$fg_no_bold[red]: To revert it, run:"
                        echo "${bold_color}SHELL PROMPT$fg_no_bold[red]:$reset_color       git config prompt.showDirtyState true"
                        echo ''
                        git config prompt.showDirtyState 'false'
                    fi
                    unset _big_repo$$
                fi
            fi


            if [ -n "${GIT_PS1_SHOWSTASHSTATE-}" ]; then
                s="$(__git_show_stash_state)"
            fi

            if [ -n "${GIT_PS1_SHOWUPSTREAM-}" ]; then
                p="$(__git_show_upstream)"
            fi
            si="$i$s"
            if [ -n "$s$p" ]; then
                i+="$R"
                p="$_Cp_$p$R"
                s="$_Cs_$s$R"
            fi
        else
            unset _big_repo$$
        fi

        local _prompt="$b$r${si:+$i$s}$p"

        # add ( ) around _prompt:
        if [ -z "$w$i$u$b" ]; then
            if [ -n "$g" ]; then
                _prompt="$_Cerror_(Error: bad ./$g dir)"
            fi
        elif [ -n "$u" ]; then
            _prompt="$_Cu_dirty_($_prompt$_Cu_dirty_)"
        else
            _prompt="$_Cu_clean_($_prompt$_Cu_clean_)"
        fi

        echo "$R$_prompt$R"
    fi
}
