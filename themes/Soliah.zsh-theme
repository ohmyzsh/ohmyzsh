PROMPT='%{$fg[blue]%}%n%{$reset_color%} on %{$fg[red]%}%M%{$reset_color%} in %{$fg[blue]%}%~%b%{$reset_color%}$(git_time_since_commit)$(git_prompt_info)
$ '

# Colors vary depending on time lapsed.
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[green]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"

function git_time_since_commit() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        now=`date +%s`
        last_commit=`git log --pretty=format:'%at' -1 2> /dev/null`
        seconds_since_last_commit=$((now-last_commit))

        MINUTES_SINCE_LAST_COMMIT=$((seconds_since_last_commit/60))

        if [ "$MINUTES_SINCE_LAST_COMMIT" -gt 30 ]; then
            COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG"
        elif [ "$MINUTES_SINCE_LAST_COMMIT" -gt 10 ]; then
            COLOR="$ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM"
        else
            COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT"
        fi
        echo "($COLOR${MINUTES_SINCE_LAST_COMMIT}m%{$reset_color%}|"
    fi
}
