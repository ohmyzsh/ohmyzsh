# Emacs 23 daemon capability is a killing feature.
# One emacs process handles all your frames whether
# you use a frame opened in a terminal via a ssh connection or X frames
# opened on the same host.

# Benefits are multiple
# - You don't have the cost of starting Emacs all the time anymore
# - Opening a file is as fast as Emacs does not have anything else to do.
# - You can share opened buffered across opened frames.
# - Configuration changes made at runtime are applied to all frames.

# Require emacs version to be minimum 24
autoload -Uz is-at-least
is-at-least 24 "${${(Az)"$(emacsclient --version 2>/dev/null)"}[2]}" || return 0

# Handle $0 according to the standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# Path to custom emacsclient launcher
export EMACS_PLUGIN_LAUNCHER="${0:A:h}/emacsclient.sh"

# set EDITOR if not already defined.
export EDITOR="${EDITOR:-${EMACS_PLUGIN_LAUNCHER}}"

alias emacs="$EMACS_PLUGIN_LAUNCHER --no-wait"
alias e=emacs
# open terminal emacsclient
alias te="$EMACS_PLUGIN_LAUNCHER -nw"

# same than M-x eval but from outside Emacs.
alias eeval="$EMACS_PLUGIN_LAUNCHER --eval"
# create a new X frame
alias eframe='emacsclient --alternate-editor "" --create-frame'

# Emacs ANSI Term tracking
if [[ -n "$INSIDE_EMACS" ]]; then
  chpwd_emacs() { print -P "\033AnSiTc %d"; }
  print -P "\033AnSiTc %d"    # Track current working directory
  print -P "\033AnSiTu %n"    # Track username

  # add chpwd hook
  autoload -Uz add-zsh-hook
  add-zsh-hook chpwd chpwd_emacs
fi

# Write to standard output the path to the file
# opened in the current buffer.
function efile {
  local cmd="(buffer-file-name (window-buffer))"
  local file="$("$EMACS_PLUGIN_LAUNCHER" --eval "$cmd" | tr -d \")"

  if [[ -z "$file" ]]; then
    echo "Can't deduce current buffer filename." >&2
    return 1
  fi

  echo "$file"
}

# Write to standard output the directory of the file
# opened in the the current buffer
function ecd {
  local file
  file="$(efile)" || return $?
  echo "${file:h}"
}
