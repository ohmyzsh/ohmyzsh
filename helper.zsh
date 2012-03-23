#
# Defines helper functions.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Checks if a file can be autoloaded by trying to load it in a subshell.
function autoloadable {
  ( unfunction $1 ; autoload -U +X $1 ) &> /dev/null
}

# Checks boolean variable for "true" (case insensitive "1", "y", "yes", "t", "true", "o", and "on").
function is-true {
  [[ -n "$1" && "$1" == (1|[Yy]([Ee][Ss]|)|[Tt]([Rr][Uu][Ee]|)|[Oo]([Nn]|)) ]]
}

# Prints the first non-empty string in the arguments array.
function coalesce {
  for arg in $argv; do
    print "$arg"
    return 0
  done
  return 1
}

# Trap signals were generated with 'kill -l'.
# DEBUG, EXIT, and ZERR are Zsh signals.
TRAP_SIGNALS=(
  ABRT ALRM BUS CHLD CONT EMT FPE HUP ILL INFO INT IO KILL PIPE PROF QUIT
  SEGV STOP SYS TERM TRAP TSTP TTIN TTOU URG USR1 USR2 VTALRM WINCH XCPU XFSZ
  DEBUG EXIT ZERR
)

# Adds a function to a list to be called when a trap is triggered.
function add-zsh-trap {
  if (( $# < 2 )); then
    print "usage: $0 type function" >&2
    return 1
  fi

  if [[ -z "$TRAP_SIGNALS[(r)$1]" ]]; then
    print "$0: unknown signal: $1" >&2
    return 1
  fi

  local trap_functions="TRAP${1}_FUNCTIONS"
  if (( ! ${(P)+trap_functions} )); then
    typeset -gaU "$trap_functions"
  fi
  eval "$trap_functions+="$2""

  if (( ! $+functions[TRAP${1}] )); then
    eval "
     function TRAP${1} {
        for trap_function in \"\$TRAP${1}_FUNCTIONS[@]\"; do
          if (( \$+functions[\$trap_function] )); then
            \"\$trap_function\" \"\$1\"
          fi
        done
        return \$(( 128 + \$1 ))
     }
    "
  fi
}

