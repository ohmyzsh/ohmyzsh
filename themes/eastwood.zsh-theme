#RVM settings
if [[ -s ~/.rvm/scripts/rvm ]] ; then
  RPS1="%{$fg[yellow]%}rvm:%{$reset_color%}%{$fg[red]%}\$(~/.rvm/bin/rvm-prompt)%{$reset_color%} $EPS1"
fi

local R="%{$terminfo[sgr0]%}"

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

    GIT_PROMPT_INFO="$dirty$R%{$fg[green]%}[$cb]$R"
}

PROMPT='$GIT_PROMPT_INFO%{$fg[cyan]%}[%~% ]%{$reset_color%}%B$%b '
