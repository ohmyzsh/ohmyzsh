## Command history configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

## History wrapper
function omz_history {
  # Delete the history file if `-c' argument provided.
  # This won't affect the `history' command output until the next login.
  if [[ "${@[(i)-c]}" -le $# ]]; then
    echo -n >| "$HISTFILE"
    echo >&2 History file deleted. Reload the session to see its effects.
  else
    fc $@ -l 1
  fi
}

# Timestamp format
case $HIST_STAMPS in
  "mm/dd/yyyy") alias history='omz_history -f' ;;
  "dd.mm.yyyy") alias history='omz_history -E' ;;
  "yyyy-mm-dd") alias history='omz_history -i' ;;
  *) alias history='omz_history' ;;
esac

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history # share command history data
