# ZSH Theme emulating the Fish shell's default prompt.

local user_color='green'; [ $UID -eq 0 ] && user_color='red'
PROMPT='%n@%m %{$fg[$user_color]%}%~%{$reset_color%}%(!.#.>) '
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'

local return_status="%{$fg_bold[red]%}%(?..%?)%{$reset_color%}"
RPROMPT='${return_status}$GIT_PROMPT_INFO%{$reset_color%}'

git_prompt_info ()
{
    if [ -z "$(git_prompt__git_dir)" ]; then
        GIT_PROMPT_INFO=''
        return
    fi

    local prompt=''

    git_prompt__branch
    prompt=" $GIT_PROMPT_BRANCH"

    git_prompt__rebase_info
    prompt="${prompt}$GIT_PROMPT_REBASE_INFO"

    git_prompt__dirty_state
    if [[ "$GIT_PROMPT_DIRTY_STATE_INDEX_ADDED" = 'yes' ]]; then
        prompt="${prompt}%{$fg[green]%} +"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_INDEX_MODIFIED" = 'yes' ]]; then
        prompt="${prompt}%{$fg[blue]%} !"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_WORKTREE_MODIFIED" = 'yes' ]]; then
        prompt="${prompt}%{$fg[blue]%} !"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_INDEX_DELETED" = 'yes' ]]; then
        prompt="${prompt}%{$fg[red]%} -"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_WORKTREE_DELETED" = 'yes' ]]; then
        prompt="${prompt}%{$fg[red]%} -"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_INDEX_RENAMED" = 'yes' ]]; then
        prompt="${prompt}%{$fg[magenta]%} >"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_INDEX_UNMERGED" = 'yes' ]]; then
        prompt="${prompt}%{$fg[yellow]%} #"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_WORKTREE_UNTRACKED" = 'yes' ]]; then
        prompt="${prompt}%{$fg[cyan]%} ?"
    fi
    GIT_PROMPT_INFO=$prompt
}
