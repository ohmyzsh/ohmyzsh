# NOTE: make sure to add 'git-prompt' to your list of oh-my-zsh plugins (in your
# ~/.zshrc), otherwise the git prompt info will not be shown.
#
#-------------------- PROMPT definition: ----------------------
# Set the prompt.

# Reset formating
local R="%{$terminfo[sgr0]%}"

# special colors for privileged users (root)
local user_="%(!.%{$fg_bold[yellow]$bg[red]%}.%{$fg_bold[cyan]%})%n$R"
local host_="%(!.%{$fg[red]%}.%{$fg_bold[blue]%})%m$R"
local path_="%(!.%{$fg_bold[white]%}.%{$fg_bold[white]%})%~$R"
local jobs_="%(1j.%{$fg[blue]%}%j$R.)"

PROMPT='$user_$host_$path_ $__GIT_PROMPT_INFO$jobs_# '

local date_format_="%D{%a %b %d}, %*"
local date_="%{$fg[green]%}[$date_format_]"
local return_code_="%(?..%{$fg[red]%}%? ↵ )"

RPROMPT='$return_code_$R$date_$R'

# use the vi-mode oh-my-zsh plugin to get this:
MODE_INDICATOR="%{$fg_bold[cyan]%}-- CMD MODE -- $R"

#
#-----------------------------------------------------
# git prompt info:

# The git-prompt plugin will cause $GIT_PROMPT_INFO_FUNC to be called
# when the git prompt info needs to be updated.
GIT_PROMPT_INFO_FUNC="update__GIT_PROMPT_INFO"

GIT_PROMPT_SHOWUPSTREAM="verbose"
GIT_PROMPT_SHORTCIRCUIT='on'

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

local __GIT_PROMPT_INFO=''
# will set __GIT_PROMPT_INFO
update__GIT_PROMPT_INFO ()
{
    local g="$(_git_promt__git_dir)"
    if [ -z "$g" ]; then
        __GIT_PROMPT_INFO=''
        return
    fi

    _git_prompt__stash
    local s=$GIT_PROMPT_STASH_STATE_DIRTY

    _git_prompt__upstream
    local p=$GIT_PROMPT_UPSTREAM_STATE

    _git_prompt__branch
    local b=$GIT_PROMPT_BRANCH

    _git_prompt__rebase_info
    local r=$GIT_PROMPT_REBASE_INFO

    _git_prompt__dirty_state
    local w=$GIT_PROMPT_DIRTY_STATE_WORKTREE_DIRTY
    local i=$GIT_PROMPT_DIRTY_STATE_INDEX_DIRTY
    local u=$GIT_PROMPT_DIRTY_STATE_WORKTREE_UNTRACKED
    local f=$GIT_PROMPT_DIRTY_STATE_FRESH_REPO

    if [ -z "$b$i$w$u" ]; then
        if [ -n "$g" ]; then
            __GIT_PROMPT_INFO="$R$_Cerror_(Error: bad ./$g dir)$R"
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

    local _prompt="$b$r$s$i$p"
    # add ( ) around _prompt:
    if [ "$f" = 'yes' ]; then
        _prompt="($_prompt)"
    elif [ "$u" = "yes" ]; then
        _prompt="$_Cu_dirty_($_prompt$_Cu_dirty_)"
    elif [ "$u" = "no" ]; then
        _prompt="$_Cu_clean_($_prompt$_Cu_clean_)"
    else
    fi

    __GIT_PROMPT_INFO="$R$_prompt$R"
}
