#!/usr/bin/env zsh
local R="%{$terminfo[sgr0]%}"
#local return_code="%(?..%{$fg[red]%}%? ↵$R)"

setopt promptsubst

autoload -U add-zsh-hook

PROMPT_FAILURE_COLOR=$FG[124]
PROMPT_VCS_INFO_COLOR=$FG[242]
PROMPT_PROMPT=$FG[077]
GIT_DIRTY_COLOR=$FG[133]
GIT_CLEAN_COLOR=$FG[118]
GIT_PROMPT_DEFAULT=$FG[012]

PROMPT='%{$FG[117]%}%~ $GIT_PROMPT_INFO $R%{$PROMPT_PROMPT%}ᐅ$R '

#RPS1="${return_code}"

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

    local dirty=''
    git_prompt__dirty_state
    if [[ "$GIT_PROMPT_DIRTY_STATE_ANY_DIRTY" = 'yes' ]]; then
        dirty=" %{$GIT_DIRTY_COLOR%}✘"
    else
        dirty=" %{$GIT_CLEAN_COLOR%}✔"
    fi

    local prompt="($R%{${branch}${dirty}%{$FG[012]%})"

    if [[ "$GIT_PROMPT_DIRTY_STATE_INDEX_ADDED" = 'yes' ]]; then
        prompt="${prompt}%{$FG[082]%}✚"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_INDEX_MODIFIED" = 'yes' ]]; then
        prompt="${prompt}%{$FG[166]%}✹"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_WORKTREE_MODIFIED" = 'yes' ]]; then
        prompt="${prompt}%{$FG[166]%}✹"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_INDEX_DELETED" = 'yes' ]]; then
        prompt="${prompt}%{$FG[160]%}✖"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_WORKTREE_DELETED" = 'yes' ]]; then
        prompt="${prompt}%{$FG[160]%}✖"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_INDEX_RENAMED" = 'yes' ]]; then
        prompt="${prompt}%{$FG[220]%}➜"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_INDEX_UNMERGED" = 'yes' ]]; then
        prompt="${prompt}%{$FG[082]%}═"
    fi
    if [[ "$GIT_PROMPT_DIRTY_STATE_WORKTREE_UNTRACKED" = 'yes' ]]; then
        prompt="${prompt}%{$FG[90]%}✭"
    fi
    GIT_PROMPT_INFO="$prompt$R"
}
