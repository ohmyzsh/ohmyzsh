# ------------------------------------------------------------------------
# Juan G. Hurtado oh-my-zsh theme
# ------------------------------------------------------------------------

# Color shortcuts
RED=$fg[red]
YELLOW=$fg[yellow]
GREEN=$fg[green]
WHITE=$fg[white]
BLUE=$fg[blue]
RED_BOLD=$fg_bold[red]
YELLOW_BOLD=$fg_bold[yellow]
GREEN_BOLD=$fg_bold[green]
WHITE_BOLD=$fg_bold[white]
BLUE_BOLD=$fg_bold[blue]
RESET_COLOR=$reset_color


# Prompt format
PROMPT='
%{$GREEN_BOLD%}%n@%m%{$WHITE%}:%{$YELLOW%}%~%u$GIT_PROMPT_INFO%{$RESET_COLOR%}
%{$BLUE%}>%{$RESET_COLOR%} '
RPROMPT='%{$GREEN_BOLD%}$GIT_RPROMPT_INFO%{$RESET_COLOR%}'

git_prompt_info ()
{
    if [ -z "$(git_prompt__git_dir)" ]; then
        GIT_PROMPT_INFO=''
        GIT_RPROMPT_INFO=''
        return
    fi

    local dirty=''
    git_prompt__dirty_state
    if [[ "$GIT_PROMPT_DIRTY_STATE_ANY_DIRTY" = 'yes' ]]; then
        dirty=" %{$RED%}(*)"
    fi
    git_prompt__upstream
    if [[ "$GIT_PROMPT_UPSTREAM_STATE" != "=" ]]; then
        local upstream=" %{$RED%}($GIT_PROMPT_UPSTREAM_STATE)"
    fi

    GIT_PROMPT_INFO="$dirty$upstream"

    git_prompt__branch
    local current_branch="$GIT_PROMPT_BRANCH"

    git_prompt__rebase_info
    current_branch="${current_branch}$GIT_PROMPT_REBASE_INFO"

    local sha=$(git rev-parse --short HEAD 2> /dev/null)
    if [[ -n "$sha" ]]; then
        sha=" %{$WHITE%}[%{$YELLOW%}$sha%{$WHITE%}]"
    fi

    local git_status=''
    if [[ "$GIT_PROMPT_DIRTY_STATE_INDEX_ADDED" = 'yes' ]]; then
        git_status="%{$GREEN%} added"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_INDEX_MODIFIED" = 'yes' ]]; then
        git_status="${git_status}%{$YELLOW%} modified"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_WORKTREE_MODIFIED" = 'yes' ]]; then
        git_status="${git_status}%{$YELLOW%} modified"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_INDEX_DELETED" = 'yes' ]]; then
        git_status="${git_status}%{$RED%} deleted"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_WORKTREE_DELETED" = 'yes' ]]; then
        git_status="${git_status}%{$RED%} deleted"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_INDEX_RENAMED" = 'yes' ]]; then
        git_status="${git_status}%{$YELLOW%} renamed"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_INDEX_UNMERGED" = 'yes' ]]; then
        git_status="${git_status}%{$RED%} unmerged"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_WORKTREE_UNTRACKED" = 'yes' ]]; then
        git_status="${git_status}%{$WHITE%} untracked"
    fi
    GIT_RPROMPT_INFO="$current_branch$sha$git_status"
}
