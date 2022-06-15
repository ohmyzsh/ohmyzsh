#!/bin/sh

emacsfun() {
  local cmd frames

  # Build the Emacs Lisp command to check for suitable frames
  # See https://www.gnu.org/software/emacs/manual/html_node/elisp/Frames.html#index-framep
  case "$*" in
  *-t*|*--tty*|*-nw*) cmd="(memq 't (mapcar 'framep (frame-list)))" ;; # if != nil, there are tty frames
  *) cmd="(delete 't (mapcar 'framep (frame-list)))" ;; # if != nil, there are graphical terminals (x, w32, ns)
  esac

  # Check if there are suitable frames
  frames="$(emacsclient -a '' -n -e "$cmd" 2>/dev/null)"

  # Only create another X frame if there isn't one present
  if [ -z "$frames" -o "$frames" = nil ]; then
    emacsclient --alternate-editor "" --create-frame "$@"
    return $?
  fi

  emacsclient --alternate-editor "" "$@"
}

# Adapted from https://github.com/davidshepherd7/emacs-read-stdin/blob/master/emacs-read-stdin.sh
# If the second argument is - then write stdin to a tempfile and open the
# tempfile. (first argument will be `--no-wait` passed in by the plugin.zsh)
if [ $# -ge 2 -a "$2" = "-" ]; then
  # Create a tempfile to hold stdin
  tempfile="$(mktemp --tmpdir emacs-stdin-$USERNAME.XXXXXXX 2>/dev/null \
    || mktemp -t emacs-stdin-$USERNAME)" # support BSD mktemp
  # Redirect stdin to the tempfile
  cat - > "$tempfile"
  # Reset $2 to the tempfile so that "$@" works as expected
  set -- "$1" "$tempfile" "${@:3}"
fi

emacsfun "$@"
