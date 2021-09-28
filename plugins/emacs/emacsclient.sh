#!/bin/sh

emacsfun() {
  local frames="$(emacsclient --alternate-editor "" -n -e "(length (frame-list))" 2>/dev/null)"

  # Only create another X frame if there isn't one present
  if [ -z "$frames" -o "$frames" -lt 2 ]; then
    emacsclient --alternate-editor "" --create-frame "$@"
    return $?
  fi

  emacsclient --alternate-editor "" "$@"
}


# adopted from https://github.com/davidshepherd7/emacs-read-stdin/blob/master/emacs-read-stdin.sh
# If the second argument is - then write stdin to a tempfile and open the
# tempfile. (first argument will be `--no-wait` passed in by the plugin.zsh)
if [ $# -ge 2 -a "$2" = "-" ]; then
  tempfile="$(mktemp --tmpdir emacs-stdin-$USERNAME.XXXXXXX 2>/dev/null \
    || mktemp -t emacs-stdin-$USERNAME)" # support BSD mktemp
  cat - > "$tempfile"
  emacsfun --no-wait "$tempfile"
  return $?
fi

emacsfun "$@"
