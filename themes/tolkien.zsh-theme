ZSH_THEME_GIT_PROMPT_PREFIX="on %F{008}git%f:%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{011}?%f"
ZSH_THEME_GIT_PROMPT_ADDED="%F{012}+%f"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[green]%}±%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%F{081}➤%f"
ZSH_THEME_GIT_PROMPT_DELETED="%F{001}-%f"
ZSH_THEME_GIT_PROMPT_UNMERGED="%F{001}✖%f"

function git_branch {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function git_ahead {
    GITSTATUS=$(git status 2> /dev/null)
    AHEAD=$(echo "$GITSTATUS" | grep '^# Your branch is ahead of' 2> /dev/null)
    if [[ -n $AHEAD ]]; then
        AHEAD=${AHEAD##\# Your branch is ahead of * by }
	AHEAD=${AHEAD%% commit.}
        echo "^%{$fg[magenta]%}"$AHEAD"%{$reset_color%}"
    fi
	
}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`')'
}

PROMPT='
╭─ %{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%M%{$reset_color%} in %{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%} $(git_branch)$(git_ahead) $(git_prompt_status)
╰─$(virtualenv_info) '
