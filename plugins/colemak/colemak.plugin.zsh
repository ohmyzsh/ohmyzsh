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

lesskey $ZSH_CUSTOM/plugins/colemak/colemak-less
