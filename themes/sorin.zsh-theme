# ------------------------------------------------------------------------------
#          FILE:  sorin.zsh-theme
#   DESCRIPTION:  oh-my-zsh theme file.
#        AUTHOR:  Sorin Ionescu (sorin.ionescu@gmail.com)
#       VERSION:  1.0.4
#    SCREENSHOT:  http://i.imgur.com/aipDQ.png
# ------------------------------------------------------------------------------


if [[ "$DISABLE_COLORS" != "true" ]]; then
    local R="%{$terminfo[sgr0]%}"
    local MAGENTA="%{$fg[magenta]%}"
    local YELLOW="%{$fg[yellow]%}"
    local GREEN="%{$fg[green]%}"
    local B_GREEN="%{$fg_bold[green]%}"
    local BLUE="%{$fg[blue]%}"
    local CYAN="%{$fg[cyan]%}"
    local RED="%{$fg[red]%}"
    local B_RED="%{$fg_bold[red]%}"
fi

MODE_INDICATOR="$B_RED❮$R$RED❮❮$R"
local return_status="$RED%(?..⏎)$R"

PROMPT='$CYAN%c$GIT_PROMPT_INFO %(!.$B_RED#.$B_GREEN❯)$R '
RPROMPT='${return_status}$GIT_RPROMPT_INFO$R'

git_prompt_info ()
{
    if [ -z "$(git_prompt__git_dir)" ]; then
        GIT_PROMPT_INFO=''
        GIT_RPROMPT_INFO=''
        return
    fi

    local branch=''

    git_prompt__branch
    branch="$GIT_PROMPT_BRANCH"

    git_prompt__rebase_info
    branch="${branch}$GIT_PROMPT_REBASE_INFO"

    GIT_PROMPT_INFO=" ${BLUE}git$R:$RED${branch}$R"

    local rprompt=''
    git_prompt__dirty_state
    if [[ "$GIT_PROMPT_DIRTY_STATE_INDEX_ADDED" = 'yes' ]]; then
        rprompt="$GREEN ✚"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_INDEX_MODIFIED" = 'yes' ]]; then
        rprompt="${rprompt}$BLUE ✹"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_WORKTREE_MODIFIED" = 'yes' ]]; then
        rprompt="${rprompt}$BLUE ✹"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_INDEX_DELETED" = 'yes' ]]; then
        rprompt="${rprompt}$RED ✖"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_WORKTREE_DELETED" = 'yes' ]]; then
        rprompt="${rprompt}$RED ✖"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_INDEX_RENAMED" = 'yes' ]]; then
        rprompt="${rprompt}$MAGENTA ➜"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_INDEX_UNMERGED" = 'yes' ]]; then
        rprompt="${rprompt}$YELLOW ═"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_WORKTREE_UNTRACKED" = 'yes' ]]; then
        rprompt="${rprompt}$CYAN ✭"
    fi
    GIT_RPROMPT_INFO=$rprompt
}
