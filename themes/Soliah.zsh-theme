PROMPT='%{$fg[blue]%}%n%{$reset_color%} on %{$fg[red]%}%M%{$reset_color%} in %{$fg[blue]%}%~%b%{$reset_color%}$(git_time_since_commit)$(git_prompt_info)
$ '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"

# Text to display if the branch is dirty
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}" 

# Text to display if the branch has untracked files
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[red]%}?%{$reset_color%}"

# Text to display if the branch is clean
ZSH_THEME_GIT_PROMPT_CLEAN="" 


# Colors vary depending on time lapsed.
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[green]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$fg[cyan]%}"

# Determine the time since last commit. If branch is clean,
# use a neutral color, otherwise colors will vary according to time.
function git_time_since_commit() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        now=`date +%s`
        last_commit=`git log --pretty=format:'%at' -1 2> /dev/null`
        seconds_since_last_commit=$((now-last_commit))

        # Total minutes
        MINUTES=$((seconds_since_last_commit / 60))
       
        # Hours and minutes
        HOURS=$((seconds_since_last_commit/3600))
        SUB_MINUTES=$((seconds_since_last_commit % 3600 / 60))

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

        if [ "$MINUTES" -gt 60 ]; then
            echo "($COLOR${HOURS}h${SUB_MINUTES}m%{$reset_color%}|"
        else
            echo "($COLOR${MINUTES}m%{$reset_color%}|"
        fi
    fi
}
