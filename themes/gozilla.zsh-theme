local R="%{$terminfo[sgr0]%}"

PROMPT='%{$fg_bold[red]%}➜ %{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$GIT_PROMPT_INFO % $R'
RPROMPT='$GIT_RPROMPT_INFO$R'

git_prompt_info ()
{
    if [ -z "$(git_prompt__git_dir)" ]; then
        GIT_PROMPT_INFO=''
        GIT_RPROMPT_INFO=''
        return
    fi

    local prompt=''

    git_prompt__branch
    prompt="$GIT_PROMPT_BRANCH"

    git_prompt__rebase_info
    prompt="${prompt}$GIT_PROMPT_REBASE_INFO"

    GIT_PROMPT_INFO="($prompt)"

    local rprompt=''
    git_prompt__dirty_state
    if [[ "$GIT_PROMPT_DIRTY_STATE_INDEX_ADDED" = 'yes' ]]; then
        rprompt="%{$fg[cyan]%} ✈"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_INDEX_MODIFIED" = 'yes' ]]; then
        rprompt="${rprompt}%{$fg[yellow]%} ✭"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_WORKTREE_MODIFIED" = 'yes' ]]; then
        rprompt="${rprompt}%{$fg[yellow]%} ✭"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_INDEX_DELETED" = 'yes' ]]; then
        rprompt="${rprompt}%{$fg[red]%} ✗"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_WORKTREE_DELETED" = 'yes' ]]; then
        rprompt="${rprompt}%{$fg[red]%} ✗"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_INDEX_RENAMED" = 'yes' ]]; then
        rprompt="${rprompt}%{$fg[blue]%} ➦"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_INDEX_UNMERGED" = 'yes' ]]; then
        rprompt="${rprompt}%{$fg[magenta]%} ✂"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_WORKTREE_UNTRACKED" = 'yes' ]]; then
        rprompt="${rprompt}%{$fg[grey]%} ✱"
    fi
    GIT_RPROMPT_INFO=$rprompt
}
