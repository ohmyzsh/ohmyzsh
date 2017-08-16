#!/bin/zsh

function exists {
    which $1 &> /dev/null
}

if exists percol; then
    ## Searching zsh history
    function percol_select_history() {
        local tac
        exists gtac && tac="gtac" || { exists tac && tac="tac" || { tac="tail -r" } }
        BUFFER=$(fc -l -n 1 | eval $tac | percol --query "$LBUFFER")
        CURSOR=$#BUFFER         # move cursor
        zle -R -c               # refresh
    }
    zle -N percol_select_history
    bindkey '^R' percol_select_history

    ## use `fg 1` just like under BASH, no need to type `fg %1`
    fg() {
        if [[ $# -eq 1 && $1 = - ]]; then
            builtin fg %-
        else
            builtin fg %"$@"
        fi
    }

    ## Interactively resume background jobs
    function percol_resume_job {
        ID=$(jobs | grep '\[\d\d*\]' | percol | sed -E 's/\[([0-9]+)\].*/\1/')
        if [[ -n ${ID} ]]; then
            fg ${ID}
        fi
        zle -R -c
    }
    zle -N percol_resume_job
    bindkey '^Q' percol_resume_job
fi
