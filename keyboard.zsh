# The default styles.
zstyle ':prompt:' vicmd '<<<'         # Indicator to notify of vi command mode.
zstyle ':prompt:' completion "..."    # Indicator to notify of generating completion.

# Beep on error in line editor.
setopt beep

# Reset to default key bindings.
bindkey -d

# Allow command line editing in an external editor.
autoload -Uz edit-command-line
zle -N edit-command-line

# Use human-friendly identifiers.
typeset -g -A keys
keys=(
  'Control'   '\C-'
  'Escape'    '\e'
  'Meta'      '\M-'
  'F1'        '^[OP'
  'F2'        '^[OQ'
  'F3'        '^[OR'
  'F4'        '^[OS'
  'F5'        '^[[15~'
  'F6'        '^[[17~'
  'F7'        '^[[18~'
  'F8'        '^[[19~'
  'F9'        '^[[20~'
  'F10'       '^[[21~'
  'F11'       '^[[23~'
  'F12'       '^[[24~'
  'Backspace' '^?'
  'Insert'    '^[[2~'
  'Home'      '^[[H'
  'PageUp'    '^[[5~'
  'Delete'    '^[[3~'
  'End'       '^[[F'
  'PageDown'  '^[[6~'
  'Up'        '^[[A'
  'Left'      '^[[D'
  'Down'      '^[[B'
  'Right'     '^[[C'
  'Menu'      '^[[29~'
)

if [[ "$KEYMAP" == (emacs|) ]]; then
  # Use Emacs key bindings.
  bindkey -e

  bindkey "${keys[Escape]}b" emacs-backward-word
  bindkey "${keys[Escape]}f" emacs-forward-word
  bindkey "${keys[Escape]}${keys[Left]}" emacs-backward-word
  bindkey "${keys[Escape]}${keys[Right]}" emacs-forward-word

  # Kill to the beginning of the line.
  bindkey "${keys[Control]}u" backward-kill-line

  # Kill to the beginning of the word.
  bindkey "${keys[Control]}w" backward-kill-word

  # Undo/Redo
  bindkey "${keys[Control]}_" undo
  bindkey "${keys[Escape]}_" redo

  # Search character.
  bindkey "${keys[Control]}]" vi-find-next-char
  bindkey "${keys[Escape]}${keys[Control]}]" vi-find-prev-char

  # Edit command in an external editor.
  bindkey "${keys[Control]}x${keys[Control]}e" edit-command-line

  # Expand .... to ../..
  if check-bool "$DOT_EXPANSION"; then
    bindkey "." expand-dot-to-parent-directory-path
  fi

  # Bind to history substring search plugin if enabled;
  # otherwise, bind to built-in ZSH history search.
  if (( ${+widgets[history-incremental-pattern-search-backward]} )); then
    bindkey "${keys[Control]}r" history-incremental-pattern-search-backward
    bindkey "${keys[Control]}s" history-incremental-pattern-search-forward
  else
    bindkey "${keys[Control]}r" history-incremental-search-backward
    bindkey "${keys[Control]}s" history-incremental-search-forward
  fi
elif [[ "$KEYMAP" == 'vi' ]]; then
  # Use vi key bindings.
  bindkey -v

  # Restores RPROMPT when exiting vicmd.
  function vi-restore-rprompt() {
    if (( $+RPROMPT_CACHED )); then
      RPROMPT="$RPROMPT_CACHED"
      unset RPROMPT_CACHED
      zle reset-prompt
      return 0
    fi
    return 1
  }
  add-zsh-trap INT vi-restore-rprompt

  # Displays the current vi mode (command).
  function zle-keymap-select() {
    if ! vi-restore-rprompt && [[ "$KEYMAP" == 'vicmd' ]]; then
      RPROMPT_CACHED="$RPROMPT"
      zstyle -s ':prompt:' vicmd RPROMPT
      zle reset-prompt
    fi
  }
  zle -N zle-keymap-select

  # Resets the prompt after exiting edit-command-line.
  function zle-line-init() {
    vi-restore-rprompt
  }
  zle -N zle-line-init

  # Resets the prompt after the line has been accepted.
  function zle-line-finish() {
    vi-restore-rprompt
  }
  zle -N zle-line-finish

  # Edit command in an external editor.
  bindkey -M vicmd "v" edit-command-line

  # Show cursor position.
  bindkey -M vicmd "ga" what-cursor-position

  # Undo/Redo
  bindkey -M vicmd "u" undo
  bindkey -M vicmd "${keys[Control]}r" redo

  # Expand .... to ../..
  if check-bool "$DOT_EXPANSION"; then
    bindkey -M viins "." expand-dot-to-parent-directory-path
  fi

  # Switch to command mode.
  bindkey -M viins "jk" vi-cmd-mode
  bindkey -M viins "kj" vi-cmd-mode

  # Emacs key bindings in insert mode.
  bindkey -M viins "${keys[Control]}a" beginning-of-line
  bindkey -M viins "${keys[Control]}b" backward-char
  bindkey -M viins "${keys[Escape]}b" emacs-backward-word
  bindkey -M viins "${keys[Control]}d" delete-char-or-list
  bindkey -M viins "${keys[Escape]}d" kill-word
  bindkey -M viins "${keys[Control]}e" end-of-line
  bindkey -M viins "${keys[Control]}f" forward-char
  bindkey -M viins "${keys[Escape]}f" emacs-forward-word
  bindkey -M viins "${keys[Control]}k" kill-line
  bindkey -M viins "${keys[Control]}u" backward-kill-line
  bindkey -M viins "${keys[Control]}w" backward-kill-word
  bindkey -M viins "${keys[Escape]}w" copy-region-as-kill
  bindkey -M viins "${keys[Escape]}h" run-help
  bindkey -M viins "${keys[Escape]}${keys[Left]}" emacs-backward-word
  bindkey -M viins "${keys[Escape]}${keys[Right]}" emacs-forward-word

  # History
  bindkey -M vicmd "gg" beginning-of-history
  bindkey -M vicmd "G" end-of-history

  # Bind to history substring search plugin if enabled;
  # otherwise, bind to built-in ZSH history search.
  if (( $+plugins[(er)history-substring-search] )); then
    bindkey -M vicmd "k" history-substring-search-up
    bindkey -M vicmd "j" history-substring-search-down
  else
    bindkey -M vicmd "k" up-line-or-history
    bindkey -M vicmd "j" down-line-or-history
  fi

  if (( ${+widgets[history-incremental-pattern-search-backward]} )); then
    bindkey -M vicmd "?" history-incremental-pattern-search-backward
    bindkey -M vicmd "/" history-incremental-pattern-search-forward

    # Emacs key bindings in insert mode.
    bindkey -M viins "${keys[Control]}r" history-incremental-pattern-search-backward
    bindkey -M viins "${keys[Control]}s" history-incremental-pattern-search-forward
  else
    bindkey -M vicmd "?" history-incremental-search-backward
    bindkey -M vicmd "/" history-incremental-search-forward

    # Emacs key bindings in insert mode.
    bindkey -M viins "${keys[Control]}r" history-incremental-search-backward
    bindkey -M viins "${keys[Control]}s" history-incremental-search-forward
  fi
else
  echo "oh-my-zsh: KEYMAP must be set 'emacs' or 'vi' but is set to '$KEYMAP'" >&2
  return 1
fi

# The next key bindings are for both Emacs and Vi.
bindkey "${keys[Home]}" beginning-of-line
bindkey "${keys[End]}" end-of-line

bindkey "${keys[Insert]}" overwrite-mode
bindkey "${keys[Delete]}" delete-char
bindkey "${keys[Backspace]}" backward-delete-char

bindkey "${keys[Left]}" backward-char
bindkey "${keys[Right]}" forward-char

# Expand history on space.
bindkey ' ' magic-space

if (( $+plugins[(er)history-substring-search] )); then
  bindkey "${keys[Up]}" history-substring-search-up
  bindkey "${keys[Down]}" history-substring-search-down
  bindkey "${keys[Control]}p" history-substring-search-up
  bindkey "${keys[Control]}n" history-substring-search-down
else
  bindkey "${keys[Up]}" up-line-or-history
  bindkey "${keys[Down]}" down-line-or-history
  bindkey "${keys[Control]}p" up-line-or-history
  bindkey "${keys[Control]}n" down-line-or-history
fi

# Clear screen.
bindkey "${keys[Control]}l" clear-screen

# Expand command name to full path.
bindkey "${keys[Escape]}e" expand-cmd-path

# Duplicate the previous word.
bindkey "${keys[Escape]}m" copy-prev-shell-word

# Bind Shift + Tab to go to the previous menu item.
bindkey '^[[Z' reverse-menu-complete

# Complete in the middle of word.
bindkey "${keys[Control]}i" expand-or-complete-prefix

# Convert .... to ../.. automatically.
if check-bool "$DOT_EXPANSION"; then
  function expand-dot-to-parent-directory-path() {
    if [[ $LBUFFER = *.. ]]; then
      LBUFFER+=/..
    else
      LBUFFER+=.
    fi
  }
  zle -N expand-dot-to-parent-directory-path
  # Do not expand .... to ../..  during incremental search.
  bindkey -M isearch . self-insert 2>/dev/null
fi

# Display an indicator when completing.
if check-bool "$COMPLETION_INDICATOR"; then
  function expand-or-complete-prefix-with-indicator() {
    zstyle -s ':prompt:' completion indicator
    print -Pn "$indicator"
    unset indicator
    zle expand-or-complete-prefix
    zle redisplay
  }
  zle -N expand-or-complete-prefix-with-indicator
  bindkey "${keys[Control]}i" expand-or-complete-prefix-with-indicator
fi

