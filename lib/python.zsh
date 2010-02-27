function wo() {
    [ -f './.venv' ] && workon `cat ./.venv`
}

alias cdv='cd $WORKON_HOME'
