# AppSignal CLI: completion, aliases and guard rails.
# https://docs.appsignal.com/cli

if (( ! $+commands[appsignal-cli] )); then
  return
fi

# Does this invocation need confirming? Sets REPLY to the reason.
#
# The command path is collected from the leading bare words. Only the global
# flags may precede a subcommand, so the first other flag ends the path: that
# way an option value such as `--app "My App"` is never mistaken for one.
function _appsignal_cli_is_destructive() {
  zstyle -T ':omz:plugins:appsignal-cli' confirm-destructive || return 1

  # Nobody to answer: CI and pipelines are unaffected.
  [[ -t 0 ]] || return 1

  local -a args=("$@") path numbers
  local arg state=""
  integer i=1 n=$# path_done=0

  while (( i <= n )); do
    arg="$args[i]"
    case "$arg" in
      --) break ;;
      --state=*) state="${arg#--state=}"; path_done=1 ;;
      --state) state="$args[i+1]"; (( i++ )); path_done=1 ;;
      --number=*) numbers+=(${(s:,:)${arg#--number=}}); path_done=1 ;;
      # --number takes one or more values, comma-separated or repeated.
      --number)
        path_done=1
        while (( i < n )) && [[ "$args[i+1]" != -* ]]; do
          (( i++ ))
          numbers+=(${(s:,:)args[i]})
        done
        ;;
      # The output flag is global, so it can appear before the subcommand.
      -o|--output|--format) (( i++ )) ;;
      -o*|--output=*|--format=*) ;;
      -*) path_done=1 ;;
      *) (( path_done )) || path+=("$arg") ;;
    esac
    (( i++ ))
  done

  case "${(j: :)path[1,3]}" in
    "logs metrics delete")
      REPLY="deleting a log-derived metric cannot be undone."
      return 0
      ;;
    "logs triggers delete")
      REPLY="deleting a log-based trigger cannot be undone."
      return 0
      ;;
    "triggers archive")
      REPLY="archiving a trigger also closes its alerts and incidents."
      return 0
      ;;
    "incidents update")
      if [[ "${(U)state}" == CLOSED ]] && (( $#numbers > 1 )); then
        REPLY="this closes $#numbers incidents at once."
        return 0
      fi
      ;;
  esac

  return 1
}

# Adds a confirmation prompt before irreversible operations. Everything else
# passes straight through, so `logs tail` keeps streaming and pipes stay clean.
function appsignal-cli() {
  local REPLY
  if _appsignal_cli_is_destructive "$@"; then
    print -u2 -- "appsignal-cli: $REPLY"
    if ! read -q "?Continue? [y/N] "; then
      print -u2 -- ""
      return 130
    fi
    print -u2 -- ""
  fi

  command appsignal-cli "$@"
}

# Complete the aliases like the commands they stand in for.
if (( $+functions[compdef] )); then
  _aslog() {
    words=(appsignal-cli logs tail ${words[2,-1]})
    (( CURRENT += 2 ))
    _appsignal-cli
  }

  _asinc() {
    words=(appsignal-cli incidents list ${words[2,-1]})
    (( CURRENT += 2 ))
    _appsignal-cli
  }

  compdef _appsignal-cli asig
  compdef _aslog aslog
  compdef _asinc asinc
fi

alias asig='appsignal-cli'
alias aslog='appsignal-cli logs tail'
alias asinc='appsignal-cli incidents list'
