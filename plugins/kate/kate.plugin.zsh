
# Kate
# Start kate always silent
alias kate='kate >/dev/null 2>&1'

function kt () {
  cd $1
  kate $1
}