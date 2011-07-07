# ------------------------------------------------------------------------------
#          FILE:  git-prompt.plugin.zsh
#   DESCRIPTION:  oh-my-zsh git information for your PROMPT.
#        AUTHOR:  Ashley Dev (the.ashley.dev+git-prompt@gmail.com)
#       VERSION:  3.0
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
#   # this is a simple example PROMPT with only git
#   # info from this plugin in it:
#   PROMPT='$GIT_PROMPT_INFO# '
# 
#   # ...
#   # If you want to override the default format you can define your own
#   # git_prompt_info() function that sets $GIT_PROMPT_INFO (or other variables)
#   # with your format:
#   git_prompt_info ()
#   {
#     if [ -z "$(git_prompt__git_dir)" ]; then
#       GIT_PROMPT_INFO=''
#       return
#     fi
#
#     git_prompt__branch
#     local branch_=$GIT_PROMPT_BRANCH
#   
#     git_prompt__dirty_state
#     local work_=$GIT_PROMPT_DIRTY_STATE_WORKTREE_DIRTY
#     local index_=$GIT_PROMPT_DIRTY_STATE_INDEX_DIRTY
#   
#     # Reset color
#     local R="%{$terminfo[sgr0]%}"
#
#     if [[ "$index_" = "yes" ]]; then
#       index_="%{$bold_color$fg[red]%}+$R"
#     else
#       index_=""
#     fi
#   
#     if [[ -n "$branch_" ]]; then
#       if [[ "$work_" = 'yes' ]]; then
#         branch_="%{$fg_no_bold[red]%}$branch_$R"
#       elif [[ "$work_" = 'no' ]]; then
#         branch_="%{$fg_no_bold[green]%}$branch_$R"
#       fi
#     fi
#   
#     GIT_PROMPT_INFO="$R($branch_$index_)$R"
#   }
# -----------------------------------------------------------------
#
#


#------------------ Default Prompt Format ------------------
# You can override this by defining your own git_prompt_info in your theme that
# sets some global variable(s); i.e. $GIT_PROMPT_INFO.
# (See the ashleydev theme for more complex usage).
git_prompt_info ()
{
  if [ -z "$(git_prompt__git_dir)" ]; then
    GIT_PROMPT_INFO=''
    return
  fi

  git_prompt__branch
  local branch=$GIT_PROMPT_BRANCH

  git_prompt__dirty_state
  local dirty=$GIT_PROMPT_DIRTY_STATE_ANY_DIRTY

  local prompt=$branch

  if [[ "$dirty" = 'yes' ]]; then
    prompt="$prompt$ZSH_THEME_GIT_PROMPT_DIRTY"
  elif [[ "$dirty" = 'no' ]]; then
    prompt="$prompt$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi

  GIT_PROMPT_INFO="$ZSH_THEME_GIT_PROMPT_PREFIX$prompt$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

#------------------ git information utils ------------------
# For some of the following functions, I borrowed some from:
#   https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
#

# sets a bunch of variables, see below:
git_prompt__dirty_state ()
{
  GIT_PROMPT_DIRTY_STATE_ANY_DIRTY=''
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

  if [[ "true" != "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]]; then
    return
  fi

  local dir_="$(git_prompt__git_dir)"
  if [[ -z "$dir_" ]]; then
    return
  fi
  if [[ "$GIT_PROMPT_SHOWDIRTYSTATE" = 'off' ]]; then
    return
  fi
  if [[ "$(git config --bool prompt.showDirtyState)" = "false" ]]; then
    return
  fi

  GIT_PROMPT_DIRTY_STATE_ANY_DIRTY='no'
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
      GIT_PROMPT_DIRTY_STATE_ANY_DIRTY='yes'
    fi
    if [[ "$line" = A* ]]; then
      GIT_PROMPT_DIRTY_STATE_INDEX_ADDED='yes'
      GIT_PROMPT_DIRTY_STATE_INDEX_DIRTY='yes'
      GIT_PROMPT_DIRTY_STATE_ANY_DIRTY='yes'
    fi
    if [[ "$line" = R* ]]; then
      GIT_PROMPT_DIRTY_STATE_INDEX_RENAMED='yes'
      GIT_PROMPT_DIRTY_STATE_INDEX_DIRTY='yes'
      GIT_PROMPT_DIRTY_STATE_ANY_DIRTY='yes'
    fi
    if [[ "$line" = C* ]]; then
      GIT_PROMPT_DIRTY_STATE_INDEX_COPIED='yes'
      GIT_PROMPT_DIRTY_STATE_INDEX_DIRTY='yes'
      GIT_PROMPT_DIRTY_STATE_ANY_DIRTY='yes'
    fi
    if [[ "$line" = D* ]]; then
      GIT_PROMPT_DIRTY_STATE_INDEX_DELETED='yes'
      GIT_PROMPT_DIRTY_STATE_INDEX_DIRTY='yes'
      GIT_PROMPT_DIRTY_STATE_ANY_DIRTY='yes'
    fi

    if [[ "$line" = \?\?* ]]; then
      GIT_PROMPT_DIRTY_STATE_WORKTREE_UNTRACKED='yes'
      GIT_PROMPT_DIRTY_STATE_ANY_DIRTY='yes'
    fi
    if [[ "$line" = ?M* ]]; then
      GIT_PROMPT_DIRTY_STATE_WORKTREE_MODIFIED='yes'
      GIT_PROMPT_DIRTY_STATE_WORKTREE_DIRTY='yes'
      GIT_PROMPT_DIRTY_STATE_ANY_DIRTY='yes'
    fi
    if [[ "$line" = ?D* ]]; then
      GIT_PROMPT_DIRTY_STATE_WORKTREE_DELETED='yes'
      GIT_PROMPT_DIRTY_STATE_WORKTREE_DIRTY='yes'
      GIT_PROMPT_DIRTY_STATE_ANY_DIRTY='yes'
    fi

    if [[ "$line" = UU* ]]; then
      GIT_PROMPT_DIRTY_STATE_INDEX_UNMERGED='yes'
      GIT_PROMPT_DIRTY_STATE_INDEX_DIRTY='yes'
      GIT_PROMPT_DIRTY_STATE_ANY_DIRTY='yes'
    fi
  done < <(git status --porcelain 2> /dev/null)
  _big_repo=''
}

# git_prompt__git_dir accepts 0 or 1 arguments (i.e., location)
# echos the location of .git repo.
# Useful for quickly figuring out if cwd is under a git repo.
git_prompt__git_dir ()
{
  if [[ -z "${1-}" ]]; then
    if [[ -d .git ]]; then
      echo .git
    else
      git rev-parse --git-dir 2>/dev/null
    fi
  elif [[ -d "$1/.git" ]]; then
    echo "$1/.git"
  else
    echo "$1"
  fi
}

# sets GIT_PROMPT_UPSTREAM_STATE
#
# output format:
# A "-1" indicates you are behind by one commit, "+3" indicates you are ahead by
# 3 commits, "-1+3" indicates you have diverged, "=" indicates no divergence,
# and "" indicates there is no upstream or this feature is turned 'off' (see
# below).
#
# You can control behaviour by setting GIT_PROMPT_SHOWUPSTREAM to a
# space-separated list of values:
#     off           no output
#     simple        Instead of '+/-', a "<" indicates you are behind, ">"
#                   indicates you are ahead, "<>" indicates you have diverged,
#                   "=" indicates no divergence.
#     legacy        don't use the '--count' option available in recent
#                   versions of git-rev-list
#     git           always compare HEAD to @{upstream}
#     svn           always compare HEAD to your SVN upstream
# By default, git_prompt__upstream will compare HEAD to your SVN upstream
# if it can find one, or @{upstream} otherwise.  Once you have
# set GIT_PROMPT_SHOWUPSTREAM, you can override it on a
# per-repository basis by setting the prompt.showUpstream config
# variable (i.e. `git config prompt.showUpstream 'simple legacy'`).
#
# git_prompt__upstream accepts 0 or 1 arguments.  If an argument is given, it
# must be a string of the form specified above for GIT_PROMPT_SHOWUPSTREAM.
# Setting this argument will override any value set for GIT_PROMPT_SHOWUPSTREAM
# or in the .git/config.
git_prompt__upstream ()
{
  GIT_PROMPT_UPSTREAM_STATE=''

  if [[ "true" != "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]]; then
    return
  fi

  local key value
  local svn_remote svn_url_pattern count n
  local upstream=git legacy="" simple=""
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

  if [[ -n "${1-}" ]]; then
    GIT_PROMPT_SHOWUPSTREAM=$1
  fi

  # parse configuration values
  for option in ${GIT_PROMPT_SHOWUPSTREAM}; do
    case "$option" in
    off) return ;;
    git|svn) upstream="$option" ;;
    simple) simple=1 ;;
    legacy) legacy=1 ;;
    esac
  done

  # Find our upstream
  case "$upstream" in
  git)  upstream="@{upstream}" ;;
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
  if [[ -n "$simple" ]]; then
    case "$count" in
    "") # no upstream
      p="" ;;
    "0 0") # equal to upstream
      p="=" ;;
    "0 "*) # ahead of upstream
      p=">" ;;
    *" 0") # behind upstream
      p="<" ;;
    *)     # diverged from upstream
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
    *)     # diverged from upstream
      p="-${count% *}+${count#* }" ;;
    esac
  fi

  GIT_PROMPT_UPSTREAM_STATE=$p
}

# sets GIT_PROMPT_REBASE_INFO
# with info about a rebase/merge/etc if it's in progress.
git_prompt__rebase_info ()
{
  GIT_PROMPT_REBASE_INFO=''

  if [[ "true" != "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]]; then
    return
  fi
  if [[ "$GIT_PROMPT_SHOWREBASEINFO" = 'off' ]]; then
    return
  fi
  if [[ "$(git config --bool prompt.showRebaseInfo)" = "false" ]]; then
    return
  fi

  local rebase_=""
  local dir_="$(git_prompt__git_dir)"
  if [[ -n "$dir_" ]]; then
    if [[ -f "$dir_/rebase-merge/interactive" ]]; then
      rebase_="|REBASE-i"
    elif [[ -d "$dir_/rebase-merge" ]]; then
      rebase_="|REBASE-m"
    else
      if [[ -d "$dir_/rebase-apply" ]]; then
        if [[ -f "$dir_/rebase-apply/rebasing" ]]; then
          rebase_="|REBASE"
        elif [[ -f "$dir_/rebase-apply/applying" ]]; then
          rebase_="|AM"
        else
          rebase_="|AM/REBASE"
        fi
      elif [[ -f "$dir_/MERGE_HEAD" ]]; then
        rebase_="|MERGING"
      elif [[ -f "$dir_/CHERRY_PICK_HEAD" ]]; then
        rebase_="|CHERRY-PICKING"
      elif [[ -f "$dir_/BISECT_LOG" ]]; then
        rebase_="|BISECTING"
      fi

    fi
  fi

  GIT_PROMPT_REBASE_INFO=$rebase_
}

# sets GIT_PROMPT_BRANCH
# with the branch name
git_prompt__branch ()
{
  GIT_PROMPT_BRANCH=''

  if [[ "true" != "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]]; then
    return
  fi

  if [[ "$GIT_PROMPT_SHOWBRANCH" = 'off' ]]; then
    return
  fi
  if [[ "$(git config --bool prompt.showBranch)" = "false" ]]; then
    return
  fi

  local branch_=""
  local dir_="$(git_prompt__git_dir)"
  if [[ -n "$dir_" ]]; then
    if [[ -f "$dir_/rebase-merge/interactive" ]]; then
      branch_="$(cat "$dir_/rebase-merge/head-name")"
    elif [[ -d "$dir_/rebase-merge" ]]; then
      branch_="$(cat "$dir_/rebase-merge/head-name")"
    else
      branch_="$(git symbolic-ref HEAD 2>/dev/null)" || {

      branch_="$(
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

        branch_="$(cut -c1-7 "$dir_/HEAD" 2>/dev/null)" ||
        branch_="$branch_"
      }
    fi
    branch_=${branch_##refs/heads/}
    if [[ "true" = "$(git rev-parse --is-inside-git-dir 2>/dev/null)" ]]; then
      if [[ "true" = "$(git rev-parse --is-bare-repository 2>/dev/null)" ]]; then
        branch_="BARE:$branch_"
      else
        branch_="GIT_DIR!"
      fi
    fi
  fi

  GIT_PROMPT_BRANCH=$branch_
}


# sets GIT_PROMPT_STASH_STATE_DIRTY
# if the git stash state is dirty
git_prompt__stash ()
{
  GIT_PROMPT_STASH_STATE_DIRTY=''

  if [[ "true" != "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]]; then
    return
  fi

  if [[ "$GIT_PROMPT_SHOWSTASHSTATE" = 'off' ]]; then
    return
  fi
  if [[ "$(git config --bool prompt.showStashState)" = "false" ]]; then
    return
  fi

  if git rev-parse --verify refs/stash >/dev/null 2>&1; then
    GIT_PROMPT_STASH_STATE_DIRTY='yes'
  else
    GIT_PROMPT_STASH_STATE_DIRTY='no'
  fi
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

_git_prompt_info ()
{
  if [[ -z $GIT_PROMPT_INFO_DISABLED ]]; then
    git_prompt_info
  fi
}

_git_prompt__precmd_update_git_vars()
{
  if [[ $ZSH_VERSION = *\ 4.2* ]]; then
    # some older versions of zsh don't have periodic_functions, so do the
    # slow path if that's the case:
    _git_prompt_info

  elif [[ -n "$__EXECUTED_GIT_COMMAND" ]]; then
    _git_prompt_info
    unset __EXECUTED_GIT_COMMAND
  fi
}
_git_prompt__preexec_update_git_vars ()
{
  case "$1" in
    g*)         __EXECUTED_GIT_COMMAND=1 ;;
    rm*)        __EXECUTED_GIT_COMMAND=1 ;;
    touch*)     __EXECUTED_GIT_COMMAND=1 ;;
    mkdir*)     __EXECUTED_GIT_COMMAND=1 ;;
    echo*)     __EXECUTED_GIT_COMMAND=1 ;;
    $EDITOR*)
      if [[ -n "$EDITOR" ]]; then
        __EXECUTED_GIT_COMMAND=1
      fi
      ;;
  esac
}

#------------------ Short Circuit ------------------
# This is the short-circuit logic:
#
# Set GIT_PROMPT_SHORTCIRCUIT='off' to turn the short-circuit logic off.
#
# Gathering dirty-state info can take a long time on large repositories.  The
# short-circuit logic is engaged by pressing ctrl-c while the prompt is trying
# to gather information about a large repository.  When this happens the
# short-circuit logic will display a warning and turn off the showing of dirty
# state in your git prompt (for the local repo only).
local _big_repo='init'
__git_prompt_shortcircuit ()
{
  if [[ "$_big_repo" == 'yes' ]]; then
    _big_repo=''
    if [[ "$GIT_PROMPT_SHORTCIRCUIT" != 'off' ]]; then
      echo "$fg[red]" > /dev/stderr
      echo "${bold_color}SHELL PROMPT$fg_no_bold[red]: Looks like you hit ctrl-c." > /dev/stderr
      echo "${bold_color}SHELL PROMPT$fg_no_bold[red]: So for this repo I'm setting:" > /dev/stderr
      echo "${bold_color}SHELL PROMPT$fg_no_bold[red]:       git config prompt.showDirtyState false" > /dev/stderr
      echo "${bold_color}SHELL PROMPT$fg_no_bold[red]: On big git repos it takes a long time to get info for your prompt." > /dev/stderr
      echo "${bold_color}SHELL PROMPT$fg_no_bold[red]: To revert it, run:" > /dev/stderr
      echo "${bold_color}SHELL PROMPT$fg_no_bold[red]:$reset_color       git config prompt.showDirtyState true" > /dev/stderr
      echo '' > /dev/stderr

      git config prompt.showDirtyState 'false'
      _git_prompt_info
    fi
  fi
}
TRAPINT ()
{
  __git_prompt_shortcircuit
  return $(( 128 + $1 ))
}
#----------------------------------------------------
