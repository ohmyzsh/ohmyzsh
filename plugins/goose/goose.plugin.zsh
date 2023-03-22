if (( ! $+commands[goose] )); then
  echo "goose not found on Path"
  return
fi


#========================#
#       FUNCTIONS        #
#========================#

function gmcs() {
  if [ -z "$1" ]; then
    echo "Must specify migration name"
    return
  fi
  goose create $1 sql
}

function gmcg() {
  if [ -z "$1" ]; then
    echo "Must specify migration name"
    return
  fi
  goose create $1 go
}

function gmut() {
  if [ -z "$1" ]; then
    echo "Must specify migration version"
    return
  fi
  goose up-to $1
}

function gmdt() {
  if [ -z "$1" ]; then
    echo "Must specify migration version"
    return
  fi
  goose down-to $1
}

#========================#
#       ALIAS            #
#========================#
alias gmu="goose up"
alias gmubo="goose up-by-one"
alias gmd="goose down"
alias gmr="goose redo"
alias gms="goose status"
alias gmv="goose version"
