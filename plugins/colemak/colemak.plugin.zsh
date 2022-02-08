# ctrl-j newline
bindkey '^n' accept-line
bindkey -a '^n' accept-line

# another rotation to match qwerty
bindkey -a 'n' down-line-or-history
bindkey -a 'e' up-line-or-history
bindkey -a 'i' vi-forward-char

# make qwerty
bindkey -a 'k' vi-repeat-search
bindkey -a 'K' vi-rev-repeat-search
bindkey -a 'u' vi-insert
bindkey -a 'U' vi-insert-bol
bindkey -a 'l' vi-undo-change
bindkey -a 'N' vi-join

# spare
bindkey -a 'j' vi-forward-word-end
bindkey -a 'J' vi-forward-blank-word-end

# Handle $0 according to the standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# New less versions will read this file directly
export LESSKEYIN="${0:h:A}/colemak-less"

# Only run lesskey if less version is older than v582
less_ver=$(less --version | awk '{print $2;exit}')
autoload -Uz is-at-least
if ! is-at-least 582 $less_ver; then
  # Old less versions will read this transformed file
  export LESSKEY="${0:h:A}/.less"
  lesskey -o "$LESSKEY" "$LESSKEYIN" 2>/dev/null
fi
unset less_ver
