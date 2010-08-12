function wo() {
    [ "$VEW_SOURCED" ] || source "$VEW_PATH"
    [ -f './.venv' ] && workon `cat ./.venv` || workon $1
    export VEW_SOURCED=1
}
alias deact='deactivate'
alias cdv='cd $WORKON_HOME'

function cdp () {
  cd "$(python -c "import os.path as _, ${1}; \
    print _.dirname(_.realpath(${1}.__file__[:-1]))"
  )"
}
