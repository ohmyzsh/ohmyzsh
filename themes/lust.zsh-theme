# ------------------------------------------------------------------------------
#          FILE:  lust.zsh-theme
#   DESCRIPTION:  oh-my-zsh theme file.
#        AUTHOR:  Steven Lu, based on kphoen.zsh-theme by Kévin Gomez (geek63@gmail.com)
#       VERSION:  0.2
# ------------------------------------------------------------------------------
 
function myjobs() {
    JOBS=`jobs -l`
    if [[ -n $JOBS ]]; then 
        print "$JOBS%{\n%}"
    fi
}
 
if [[ "$TERM" != "dumb" ]] && [[ "$DISABLE_LS_COLORS" != "true" ]]; then
    PROMPT='%{$fg[red]%}%n%{$reset_color%}@%{$fg[green]%}%m%{$reset_color%}:%{$fg[blue]%}%~%{$reset_color%} %{$fg[yellow]%}%W %T%{$fg[magenta]%} %!%{$reset_color%}
$(myjobs)%(!.%{$fg[red]%}#.%{$fg[cyan]%}❯)%{$reset_color%} '
 
    ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
 
    ZSH_THEME_GIT_PROMPT_SHA_BEFORE="%{$fg[blue]%}"
    ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}"
 
    ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[grey]%}[%{$fg[yellow]%}⚡%{$fg[grey]%}]%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[grey]%}[%{$fg[green]%}✓%{$fg[grey]%}]%{$reset_color%}"
 
    ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[cyan]%}↑%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[red]%}↓%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_DIVERGED="%{$fg[magenta]%}↕%{$reset_color%}"
 
    ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✚"
    ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}✎"
    ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖"
    ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[cyan]%}➜"
    ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%}♦"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[blue]%}✭"
    ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[cyan]%}$"
 
    # Colors vary depending on time lapsed.
    ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[green]%}"
    ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
    ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"
    ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$reset_color%}"

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
                    echo "$COLOR${DAYS}d${SUB_HOURS}h${SUB_MINUTES}m%{$reset_color%}"
                elif [ "$MINUTES" -gt 60 ]; then
                    echo "$COLOR${HOURS}h${SUB_MINUTES}m%{$reset_color%}"
                else
                    echo "$COLOR${MINUTES}m%{$reset_color%}"
                fi
            else
                COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
                echo "$COLOR~"
            fi
        fi
    }
    function my_git_prompt_status_and_time() {
        #wrap git prompt status with stuff 
        NOW_GIT_PROMPT_STATUS="$(git_prompt_status)"
        NOW_GIT_TIME_SINCE="$(git_time_since_commit)"
        if [[ -n $NOW_GIT_PROMPT_STATUS ]]; then 
            echo "%{$fg[grey]%}[$NOW_GIT_PROMPT_STATUS%{$fg[grey]%}]$NOW_GIT_TIME_SINCE%{$reset_color%}"
        else
            if [[ -n $NOW_GIT_TIME_SINCE ]]; then
                echo "%{$fg[grey]%}‖$NOW_GIT_TIME_SINCE%{$reset_color%}"
            fi
        fi
    }

    # display exitcode on the right when >0
    return_code="%(?..%{$fg[magenta]%}%? ↲ %{$reset_color%}) "
 
    RPROMPT='${return_code}$(git_prompt_info)$(git_prompt_short_sha)$(my_git_prompt_status_and_time)'

else
    PROMPT='[%n@%m:%~$(git_prompt_info)]
%# '
 
    ZSH_THEME_GIT_PROMPT_PREFIX=" on"
    ZSH_THEME_GIT_PROMPT_SUFFIX=""
    ZSH_THEME_GIT_PROMPT_DIRTY=""
    ZSH_THEME_GIT_PROMPT_CLEAN=""
 
    # display exitcode on the right when >0
    return_code="%(?..%? ↵)"
 
    RPROMPT='${return_code}$(git_prompt_status)'
 
    ZSH_THEME_GIT_PROMPT_ADDED=" ✚"
    ZSH_THEME_GIT_PROMPT_MODIFIED=" ✹"
    ZSH_THEME_GIT_PROMPT_DELETED=" ✖"
    ZSH_THEME_GIT_PROMPT_RENAMED=" ➜"
    ZSH_THEME_GIT_PROMPT_UNMERGED=" ═"
    ZSH_THEME_GIT_PROMPT_UNTRACKED=" ✭"
fi
