# Dumb terminals lack support.
if [[ "$TERM" == 'dumb' ]]; then
  return
fi

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
zmodload zsh/terminfo
typeset -g -A keyinfo
keyinfo=(
  'Control'   '\C-'
  'Escape'    '\e'
  'Meta'      '\M-'
  'F1'        "${terminfo[kf1]}"
  'F2'        "${terminfo[kf2]}"
  'F3'        "${terminfo[kf3]}"
  'F4'        "${terminfo[kf4]}"
  'F5'        "${terminfo[kf5]}"
  'F6'        "${terminfo[kf6]}"
  'F7'        "${terminfo[kf7]}"
  'F8'        "${terminfo[kf8]}"
  'F9'        "${terminfo[kf9]}"
  'F10'       "${terminfo[kf10]}"
  'F11'       "${terminfo[kf11]}"
  'F12'       "${terminfo[kf12]}"
  'Backspace' "${terminfo[kbs]}"
  'Insert'    "${terminfo[kich1]}"
  'Home'      "${terminfo[khome]}"
  'PageUp'    "${terminfo[kpp]}"
  'Delete'    "${terminfo[kdch1]}"
  'End'       "${terminfo[kend]}"
  'PageDown'  "${terminfo[knp]}"
  'Up'        "${terminfo[kcuu1]}"
  'Left'      "${terminfo[kcub1]}"
  'Down'      "${terminfo[kcud1]}"
  'Right'     "${terminfo[kcuf1]}"
  'BackTab'   "${terminfo[kcbt]}"
)

if [[ "$KEYMAP" == (emacs|) ]]; then
  # Use Emacs key bindings.
  bindkey -e

  bindkey "${keyinfo[Escape]}b" emacs-backward-word
  bindkey "${keyinfo[Escape]}f" emacs-forward-word
  bindkey "${keyinfo[Escape]}${keyinfo[Left]}" emacs-backward-word
  bindkey "${keyinfo[Escape]}${keyinfo[Right]}" emacs-forward-word

  # Kill to the beginning of the line.
  bindkey "${keyinfo[Control]}u" backward-kill-line

  # Kill to the beginning of the word.
  bindkey "${keyinfo[Control]}w" backward-kill-word

  # Undo/Redo
  bindkey "${keyinfo[Control]}_" undo
  bindkey "${keyinfo[Escape]}_" redo

  # Search character.
  bindkey "${keyinfo[Control]}]" vi-find-next-char
  bindkey "${keyinfo[Escape]}${keyinfo[Control]}]" vi-find-prev-char

  # Edit command in an external editor.
  bindkey "${keyinfo[Control]}x${keyinfo[Control]}e" edit-command-line

  # Expand .... to ../..
  if check-bool "$DOT_EXPANSION"; then
    bindkey "." expand-dot-to-parent-directory-path
  fi

  # Bind to history substring search plugin if enabled;
  # otherwise, bind to built-in ZSH history search.
  if (( ${+widgets[history-incremental-pattern-search-backward]} )); then
    bindkey "${keyinfo[Control]}r" history-incremental-pattern-search-backward
    bindkey "${keyinfo[Control]}s" history-incremental-pattern-search-forward
  else
    bindkey "${keyinfo[Control]}r" history-incremental-search-backward
    bindkey "${keyinfo[Control]}s" history-incremental-search-forward
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
  bindkey -M vicmd "${keyinfo[Control]}r" redo

  # Expand .... to ../..
  if check-bool "$DOT_EXPANSION"; then
    bindkey -M viins "." expand-dot-to-parent-directory-path
  fi

  # Switch to command mode.
  bindkey -M viins "jk" vi-cmd-mode
  bindkey -M viins "kj" vi-cmd-mode

  # Emacs key bindings in insert mode.
  bindkey -M viins "${keyinfo[Control]}a" beginning-of-line
  bindkey -M viins "${keyinfo[Control]}b" backward-char
  bindkey -M viins "${keyinfo[Escape]}b" emacs-backward-word
  bindkey -M viins "${keyinfo[Control]}d" delete-char-or-list
  bindkey -M viins "${keyinfo[Escape]}d" kill-word
  bindkey -M viins "${keyinfo[Control]}e" end-of-line
  bindkey -M viins "${keyinfo[Control]}f" forward-char
  bindkey -M viins "${keyinfo[Escape]}f" emacs-forward-word
  bindkey -M viins "${keyinfo[Control]}k" kill-line
  bindkey -M viins "${keyinfo[Control]}u" backward-kill-line
  bindkey -M viins "${keyinfo[Control]}w" backward-kill-word
  bindkey -M viins "${keyinfo[Escape]}w" copy-region-as-kill
  bindkey -M viins "${keyinfo[Escape]}h" run-help
  bindkey -M viins "${keyinfo[Escape]}${keyinfo[Left]}" emacs-backward-word
  bindkey -M viins "${keyinfo[Escape]}${keyinfo[Right]}" emacs-forward-word

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
    bindkey -M viins "${keyinfo[Control]}r" history-incremental-pattern-search-backward
    bindkey -M viins "${keyinfo[Control]}s" history-incremental-pattern-search-forward
  else
    bindkey -M vicmd "?" history-incremental-search-backward
    bindkey -M vicmd "/" history-incremental-search-forward

    # Emacs key bindings in insert mode.
    bindkey -M viins "${keyinfo[Control]}r" history-incremental-search-backward
    bindkey -M viins "${keyinfo[Control]}s" history-incremental-search-forward
  fi
else
  echo "oh-my-zsh: KEYMAP must be set 'emacs' or 'vi' but is set to '$KEYMAP'" >&2
  return 1
fi

# The next key bindings are for both Emacs and Vi.
bindkey "${keyinfo[Home]}" beginning-of-line
bindkey "${keyinfo[End]}" end-of-line

bindkey "${keyinfo[Insert]}" overwrite-mode
bindkey "${keyinfo[Delete]}" delete-char
bindkey "${keyinfo[Backspace]}" backward-delete-char

bindkey "${keyinfo[Left]}" backward-char
bindkey "${keyinfo[Right]}" forward-char

# Expand history on space.
bindkey ' ' magic-space

if (( $+plugins[(er)history-substring-search] )); then
  bindkey "${keyinfo[Up]}" history-substring-search-up
  bindkey "${keyinfo[Down]}" history-substring-search-down
  bindkey "${keyinfo[Control]}p" history-substring-search-up
  bindkey "${keyinfo[Control]}n" history-substring-search-down
else
  bindkey "${keyinfo[Up]}" up-line-or-history
  bindkey "${keyinfo[Down]}" down-line-or-history
  bindkey "${keyinfo[Control]}p" up-line-or-history
  bindkey "${keyinfo[Control]}n" down-line-or-history
fi

# Clear screen.
bindkey "${keyinfo[Control]}l" clear-screen

# Expand command name to full path.
bindkey "${keyinfo[Escape]}e" expand-cmd-path

# Duplicate the previous word.
bindkey "${keyinfo[Escape]}m" copy-prev-shell-word

# Bind Shift + Tab to go to the previous menu item.
bindkey "${keyinfo[BackTab]}" reverse-menu-complete

# Complete in the middle of word.
bindkey "${keyinfo[Control]}i" expand-or-complete-prefix

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
  bindkey "${keyinfo[Control]}i" expand-or-complete-prefix-with-indicator
fi

