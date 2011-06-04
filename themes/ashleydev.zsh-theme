# ------------------------------------------------------------------------------
#          FILE:  ashleydev.theme.zsh
#   DESCRIPTION:  oh-my-zsh prompt theme, shows vi mode, last shell return code,
#                 and verbose git info.
#        AUTHOR:  Ashley Dev (the.ashley.dev+zsh-theme@gmail.com)
#       VERSION:  3.0
#    SCREENSHOT:  http://i.imgur.com/Yw1KG.png
#                 http://i.imgur.com/wx6MU.png
# ------------------------------------------------------------------------------

# NOTE: make sure to add 'git' to your list of oh-my-zsh plugins (in your
# ~/.zshrc), otherwise the git prompt info will not be shown.

#-------------------- Colors ----------------------
# Colors ('_C' for color):
if [[ "$DISABLE_COLOR" != "true" ]]; then
    # Reset formating:
    local R="%{$terminfo[sgr0]%}"

    # git prompt info colors:
    local _Cerror_="%{$fg[yellow]%}"                 # bad (empty) .git/ directory
    local _Cbranch_new_repo_="%{$fg_bold[default]%}" # branch color of new repo
    local _Cbranch_clean_="%{$fg_no_bold[green]%}"   # branch color when clean
    local _Cbranch_dirty_="%{$fg_no_bold[red]%}"     # branch color when dirty
    local _Crebase_="%{$bold_color$fg[yellow]%}"     # rebase info
    local _Cindex_="%{$bold_color$fg[red]%}"         # index info
    local _Cuntracked_clean_=""                      # untracked files state when clean
    local _Cuntracked_dirty_="%{$fg_bold[red]%}"     # untracked files state when dirty
    local _Cupstream_="%{${fg[cyan]}%}"              # upstream info
    local _Cstash_=""                                # stash state

    # PROMPT colors:
    local _Cuser_root_="%{$fg_bold[yellow]$bg[red]%}"
    local _Chost_root_="%{$fg[red]%}"
    local _Cpath_root_="%{$fg_bold[white]%}"
    local _Cuser_="%{$fg_bold[cyan]%}"
    local _Chost_="%{$fg_bold[blue]%}"
    local _Cpath_="%{$fg_bold[white]%}"
    local _Cjobs_="%{$fg[blue]%}"

    # RPROMPT colors:
    local _Cdate_="%{$fg[green]%}"
    local _Creturn_code_="%{$fg[red]%}"
    local _Cvi_mode_="%{$fg_bold[cyan]%}"
fi

#-------------------- PROMPT definition: ----------------------
#

local user_="%(!.$_Cuser_root_.$_Cuser_)%n$R"
local host_="%(!.$_Chost_root_.$_Chost_)%m$R"
local path_="%(!.$_Cpath_root_.$_Cpath_)%~$R"
local jobs_="%(1j.$_Cjobs_%j$R.)"

PROMPT='$user_$host_$path_ $GIT_PROMPT_INFO$jobs_# '

local date_format_='%D{%a %b %d}, %*'
local date_="${_Cdate_}[$date_format_]$R"
local return_code_="%(?..$_Creturn_code_%? ↵ )$R"

RPROMPT='$return_code_$date_'

# use the vi-mode oh-my-zsh plugin to get this:
MODE_INDICATOR="${_Cvi_mode_}-- CMD MODE -- $R"


#-------------------- Git prompt info format: ----------------------
git_prompt_info ()
{
  local dir_="$(git_prompt__git_dir)"
  if [ -z "$dir_" ]; then
    GIT_PROMPT_INFO=''
    return
  fi

  git_prompt__stash
  local stash_=$GIT_PROMPT_STASH_STATE_DIRTY

  git_prompt__upstream
  local upstream_=$GIT_PROMPT_UPSTREAM_STATE

  git_prompt__branch
  local branch_=$GIT_PROMPT_BRANCH

  git_prompt__rebase_info
  local rebase_=$GIT_PROMPT_REBASE_INFO

  git_prompt__dirty_state
  local work_=$GIT_PROMPT_DIRTY_STATE_WORKTREE_DIRTY
  local index_=$GIT_PROMPT_DIRTY_STATE_INDEX_DIRTY
  local untracked_=$GIT_PROMPT_DIRTY_STATE_WORKTREE_UNTRACKED
  local freshy_=$GIT_PROMPT_DIRTY_STATE_FRESH_REPO

  if [ -z "$branch_$index_$work_$untracked_" ]; then
    if [ -n "$dir_" ]; then
      GIT_PROMPT_INFO="$R$_Cerror_(Error: bad ./$dir_ dir)$R"
      return
    fi
  fi

  if [ "$stash_" = 'yes' ]; then
    stash_="$_Cstash_\$$R"
  else
    stash_=""
  fi

  if [ -n "$upstream_" ]; then
    upstream_="$_Cupstream_$upstream_$R"
  fi

  if [ "$index_" = "yes" ]; then
    index_="$_Cindex_+$R"
  else
    index_=""
  fi

  if [ -n "$branch_" ]; then
    if [ "$freshy_" = "yes" ]; then
      # this is a fresh repo, nothing here...
      branch_="$_Cbranch_new_repo_$branch_$R"
    elif [ "$work_" = 'yes' ]; then
      branch_="$_Cbranch_dirty_$branch_$R"
    elif [ "$work_" = 'no' ]; then
      branch_="$_Cbranch_clean_$branch_$R"
    fi
  fi

  if [ -n "$rebase_" ]; then
    rebase_="$_Crebase_$rebase_$R"
  fi

  local _prompt="$branch_$rebase_$index_$stash_$upstream_"
  # add ( ) around _prompt:
  if [ "$untracked_" = "yes" ]; then
    _prompt="$_Cuntracked_dirty_($_prompt$_Cuntracked_dirty_)"
  elif [ "$untracked_" = "no" ]; then
    _prompt="$_Cuntracked_clean_($_prompt$_Cuntracked_clean_)"
  else
    _prompt="($_prompt)"
  fi

  GIT_PROMPT_INFO="$R$_prompt$R"
}
