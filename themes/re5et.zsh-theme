if [ "$(whoami)" = "root" ]; then CARETCOLOR="red"; else CARETCOLOR="magenta"; fi

local return_code="%(?..%{$fg_bold[red]%}:( %?%{$reset_color%})"

PROMPT='
%{$fg_bold[cyan]%}%n%{$reset_color%}%{$fg[yellow]%}@%{$reset_color%}%{$fg_bold[blue]%}%m%{$reset_color%}:%{${fg_bold[green]}%}%~%{$reset_color%}$GIT_PROMPT_INFO
%{${fg[$CARETCOLOR]}%}%# %{${reset_color}%}'

RPS1='${return_code} %D - %*'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[magenta]%}^%{$reset_color%}%{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%} ±"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ?"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[red]%} ♥"

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
            prompt="$prompt%{$fg_bold[red]%}±"
        fi
        if [[ "$GIT_PROMPT_DIRTY_STATE_WORKTREE_UNTRACKED" = 'yes' ]]; then
            prompt="$prompt%{$fg[cyan]%}?"
        fi
        if [[ "$GIT_PROMPT_DIRTY_STATE_ANY_DIRTY" = 'no' ]]; then
            prompt="$prompt%{$fg_bold[red]%}♥"
        fi

        GIT_PROMPT_INFO="%{$fg_bold[magenta]%}^%{$reset_color%}%{$fg_bold[yellow]%}$prompt%{$reset_color%}"
    fi
}
