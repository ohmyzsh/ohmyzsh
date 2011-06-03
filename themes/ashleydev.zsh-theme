# ------------------------------------------------------------------------------
#          FILE:  ashleydev.theme.zsh
#   DESCRIPTION:  oh-my-zsh prompt theme, shows vi mode, last shell return code,
#                 and verbose git info.
#        AUTHOR:  Ashley Dev (the.ashley.dev+zsh-theme@gmail.com)
#       VERSION:  2.1
#    SCREENSHOT:  http://i.imgur.com/Yw1KG.png
#                 http://i.imgur.com/wx6MU.png
# ------------------------------------------------------------------------------

# NOTE: make sure to add 'git' to your list of oh-my-zsh plugins (in your
# ~/.zshrc), otherwise the git prompt info will not be shown.

#-------------------- Colors ----------------------
# Colors ('_C' for color):
if [[ "$DISABLE_COLOR" != "true" ]]; then
    # git prompt info colors:
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

    # Reset formating:
    local R="%{$terminfo[sgr0]%}"

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

#-----------------------------------------------------
# git prompt info:

# The git prompt plugin will cause $GIT_PROMPT_INFO_FUNC to be called
# when $_GIT_PROMPT_INFO needs to be updated.
GIT_PROMPT_INFO_FUNC="update__GIT_PROMPT_INFO"
GIT_PROMPT_SHOWUPSTREAM="verbose"
GIT_PROMPT_SHORTCIRCUIT='on'

local _GIT_PROMPT_INFO=''
# will set _GIT_PROMPT_INFO
update__GIT_PROMPT_INFO ()
{
    local g="$(git_prompt__git_dir)"
    if [ -z "$g" ]; then
        _GIT_PROMPT_INFO=''
        return
    fi

    git_prompt__stash
    local s=$GIT_PROMPT_STASH_STATE_DIRTY

    git_prompt__upstream
    local p=$GIT_PROMPT_UPSTREAM_STATE

    git_prompt__branch
    local b=$GIT_PROMPT_BRANCH

    git_prompt__rebase_info
    local r=$GIT_PROMPT_REBASE_INFO

    git_prompt__dirty_state
    local w=$GIT_PROMPT_DIRTY_STATE_WORKTREE_DIRTY
    local i=$GIT_PROMPT_DIRTY_STATE_INDEX_DIRTY
    local u=$GIT_PROMPT_DIRTY_STATE_WORKTREE_UNTRACKED
    local f=$GIT_PROMPT_DIRTY_STATE_FRESH_REPO

    if [ -z "$b$i$w$u" ]; then
        if [ -n "$g" ]; then
            _GIT_PROMPT_INFO="$R$_Cerror_(Error: bad ./$g dir)$R"
            return
        fi
    fi

    if [ "$s" = 'yes' ]; then
        s="$_Cs_\$$R"
    else
        s=""
    fi

    if [ -n "$p" ]; then
        p="$_Cp_$p$R"
    fi

    if [ "$i" = "yes" ]; then
        i="$_Ci_+$R"
    else
        i=""
    fi

    if [ -n "$b" ]; then
        if [ "$f" = "yes" ]; then
            # this is a fresh repo, nothing here...
            b="$_Cb_new_repo_$b$R"
        elif [ "$w" = 'yes' ]; then
            b="$_Cb_dirty_$b$R"
        elif [ "$w" = 'no' ]; then
            b="$_Cb_clean_$b$R"
        fi
    fi

    if [ -n "$r" ]; then
        r="$_Cr_$r$R"
    fi

    local _prompt="$b$r$i$s$p"
    # add ( ) around _prompt:
    if [ "$u" = "yes" ]; then
        _prompt="$_Cu_dirty_($_prompt$_Cu_dirty_)"
    elif [ "$u" = "no" ]; then
        _prompt="$_Cu_clean_($_prompt$_Cu_clean_)"
    else
        _prompt="($_prompt$)"
    fi

    _GIT_PROMPT_INFO="$R$_prompt$R"
}


#-------------------- PROMPT definition: ----------------------
#
local user_="%(!.$_Cuser_root_.$_Cuser_)%n$R"
local host_="%(!.$_Chost_root_.$_Chost_)%m$R"
local path_="%(!.$_Cpath_root_.$_Cpath_)%~$R"
local jobs_="%(1j.$_Cjobs_%j$R.)"

PROMPT='$user_$host_$path_ $_GIT_PROMPT_INFO$jobs_# '

local date_format_='%D{%a %b %d}, %*'
local date_="${_Cdate_}[$date_format_]$R"
local return_code_="%(?..$_Creturn_code_%? ↵ )$R"

RPROMPT='$return_code_$date_'

# use the vi-mode oh-my-zsh plugin to get this:
MODE_INDICATOR="${_Cvi_mode_}-- CMD MODE -- $R"

