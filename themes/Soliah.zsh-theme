local R="%{$terminfo[sgr0]%}"

PROMPT='%{$fg[blue]%}%n$R on %{$fg[red]%}%M$R in %{$fg[blue]%}%~%b$R$GIT_PROMPT_INFO
$ '

git_prompt_info ()
{
    if [ -z "$(git_prompt__git_dir)" ]; then
        GIT_PROMPT_INFO="($(rvm_gemset)$R)"
        return
    fi

    local prompt=''

    git_prompt__branch
    prompt="%{$fg[white]%}$GIT_PROMPT_BRANCH"

    git_prompt__rebase_info
    prompt="${prompt}$GIT_PROMPT_REBASE_INFO"

    git_prompt__dirty_state
    if [[ "$GIT_PROMPT_DIRTY_STATE_ANY_DIRTY" = 'yes' ]]; then
        prompt="${prompt}%{$fg[red]%}*"
    fi

    GIT_PROMPT_INFO="($(rvm_gemset)$(git_time_since_commit)$prompt$R)"
}

# Colors vary depending on time lapsed.
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[green]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$fg[cyan]%}"


# Determine if we are using a gemset.
function rvm_gemset() {
    GEMSET=`rvm gemset list | grep '=>' | cut -b4-`
    if [[ -n $GEMSET ]]; then
        echo "%{$fg[yellow]%}${GEMSET}$R|"
    fi

}

# Determine the time since last commit. If branch is clean,
# use a neutral color, otherwise colors will vary according to time.
function git_time_since_commit() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        # Only proceed if there is actually a commit.
        if [[ $(git log 2>&1 > /dev/null | grep -c "^fatal: bad default revision") == 0 ]]; then
            # Get the last commit.
            last_commit=`git log --pretty=format:'%at' -1 2> /dev/null`
            now=`date +%s`
            seconds_since_last_commit=$((now-last_commit))

            # Totals
            MINUTES=$((seconds_since_last_commit / 60))
            HOURS=$((seconds_since_last_commit/3600))

            # Sub-hours and sub-minutes
            DAYS=$((seconds_since_last_commit / 86400))
            SUB_HOURS=$((HOURS % 24))
            SUB_MINUTES=$((MINUTES % 60))

            if [[ -n $(git status -s 2> /dev/null) ]]; then
                if [ "$MINUTES" -gt 30 ]; then
                    COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG"
                elif [ "$MINUTES" -gt 10 ]; then
                    COLOR="$ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM"
                else
                    COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT"
                fi
            else
                COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
            fi

            if [ "$HOURS" -gt 24 ]; then
                echo "$COLOR${DAYS}d${SUB_HOURS}h${SUB_MINUTES}m$R|"
            elif [ "$MINUTES" -gt 60 ]; then
                echo "$COLOR${HOURS}h${SUB_MINUTES}m$R|"
            else
                echo "$COLOR${MINUTES}m$R|"
            fi
        else
            COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
            echo "$COLOR~|"
        fi
    fi
}
