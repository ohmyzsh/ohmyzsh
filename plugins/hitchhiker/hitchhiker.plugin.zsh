# Handle $0 according to the standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

HITCHHIKER_DIR="${0:h}/fortunes"

# Aliases
alias hitchhiker="fortune -a $HITCHHIKER_DIR"
alias hitchhiker_cow="hitchhiker | cowthink"

() {
  # Don't generate hitchhiker.dat if it exists and is up-to-date
  if [[ -f "$HITCHHIKER_DIR/hitchhiker.dat" ]] && ! [[ "$HITCHHIKER_DIR/hitchhiker.dat" -ot "$HITCHHIKER_DIR/hitchhiker" ]]; then
    return
  fi

  # If strfile is not found: some systems install strfile in /usr/sbin but it's not in $PATH
  if ! command -v strfile &>/dev/null && ! [[ -f /usr/sbin/strfile ]]; then
    echo "[oh-my-zsh] hitchhiker depends on strfile, which is not installed" >&2
    echo "[oh-my-zsh] strfile is often provided as part of the 'fortune' package" >&2
    return
  fi

  "${commands[strfile]:-/usr/sbin/strfile}" "$HITCHHIKER_DIR/hitchhiker" "$HITCHHIKER_DIR/hitchhiker.dat" >/dev/null
}

unset HITCHHIKER_DIR
