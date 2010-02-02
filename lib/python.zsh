function wo() {
    [ -f './.venv' ] && workon `cat ./.venv`
}
