# Aliases
alias kate='kate >/dev/null 2>&1' # Silent start.

# Functions
function kt() {
  if [[ -z "$1" ]]; then
    kate .
  else
    ( [[ -d "$1" ]] && cd "$1" && kate . )
  fi
}

