if (( $+commands[plz] )); then
    source <(plz --completion_script)
fi

alias pb='plz build'
alias pt='plz test'
alias pw='plz watch'
