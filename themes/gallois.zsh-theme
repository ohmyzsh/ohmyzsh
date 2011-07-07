git_prompt_info ()
{
    if [ -z "$(git_prompt__git_dir)" ]; then
        GIT_PROMPT_INFO=''
        return
    fi

    git_prompt__branch
    local cb=$GIT_PROMPT_BRANCH

    git_prompt__rebase_info
    cb="${cb}$GIT_PROMPT_REBASE_INFO"

    local dirty
    git_prompt__dirty_state
    if [[ "$GIT_PROMPT_DIRTY_STATE_ANY_DIRTY" = 'yes' ]]; then
        dirty="%{$fg[red]%}*%{$reset_color%}"
    fi

    local R="%{$terminfo[sgr0]%}"

    GIT_PROMPT_INFO="$dirty$R%{$fg[green]%}[$cb]$R"
}

#RVM and git settings
if [[ -s ~/.rvm/scripts/rvm ]] ; then
  RPS1='$GIT_PROMPT_INFO%{$fg[red]%}[`~/.rvm/bin/rvm-prompt`]%{$reset_color%} $EPS1'
fi

PROMPT='%{$fg[cyan]%}[%~% ]%(?.%{$fg[green]%}.%{$fg[red]%})%B$%b '
