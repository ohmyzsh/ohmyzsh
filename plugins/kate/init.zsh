# Aliases
alias kate='kate >/dev/null 2>&1' # Silent start.

# Functions
function kt() {
  cd "$1"
  kate "$1"
}

