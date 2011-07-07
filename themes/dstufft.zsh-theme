function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    hg root >/dev/null 2>/dev/null && echo 'Hg' && return
    echo '○'
}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

PROMPT='
%{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in %{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}$GIT_PROMPT_INFO
$(virtualenv_info)$(prompt_char) '

git_prompt_info ()
{
    if [ -z "$(git_prompt__git_dir)" ]; then
        GIT_PROMPT_INFO=''
        return
    fi

    local prompt=""
    git_prompt__branch
    prompt=$GIT_PROMPT_BRANCH

    git_prompt__rebase_info
    prompt="${prompt}$GIT_PROMPT_REBASE_INFO"

    if [[ -n "$prompt" ]]; then
        git_prompt__dirty_state
        if [[ "$GIT_PROMPT_DIRTY_STATE_ANY_DIRTY" = 'yes' ]]; then
            prompt="$prompt%{$fg[green]%}!"
        fi
        if [[ "$GIT_PROMPT_DIRTY_STATE_WORKTREE_UNTRACKED" = 'yes' ]]; then
            prompt="$prompt%{$fg[green]%}?"
        fi

        GIT_PROMPT_INFO=" on %{$fg[magenta]%}$prompt%{$reset_color%}"
    fi
}
