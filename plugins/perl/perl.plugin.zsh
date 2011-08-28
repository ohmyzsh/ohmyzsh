# Aliases
alias pbi='perlbrew install'
alias pbl='perlbrew list'
alias pbo='perlbrew off'
alias pbs='perlbrew switch'
alias pbu='perlbrew use'
alias ple='perl -wlne'
alias pd='perldoc'

# Perl Global Substitution
function pgs() {
  if (( $# < 2 )) ; then
    echo "Usage: $0 find replace [file ...]" >&2
    return 1
  fi

  local find="$1"
  local replace="$2"
  repeat 2 shift

  perl -i.orig -pe 's/'"$find"'/'"$replace"'/g' "$@"
}

# Perl grep since 'grep -P' is terrible.
function prep() {
  if (( $# < 1 )) ; then
    echo "Usage: $0 pattern [file ...]" >&2
    return 1
  fi

  local pattern="$1"
  shift

  perl -nle 'print if /'"$pattern"'/;' "$@"
}

