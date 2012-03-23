#
# Sets keyboard bindings.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Dumb terminals lack support.
if [[ "$TERM" == 'dumb' ]]; then
  return
fi

# The default styles.

# Indicator to notify of vi insert mode.
zstyle ':omz:prompt:vi' insert '>>>'

# Indicator to notify of vi command mode.
zstyle ':omz:prompt:vi' command '<<<'

# Indicator to notify of generating completion.
zstyle ':omz:completion' indicator '...'

# Beep on error in line editor.
setopt BEEP

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
  'F1'        "$terminfo[kf1]"
  'F2'        "$terminfo[kf2]"
  'F3'        "$terminfo[kf3]"
  'F4'        "$terminfo[kf4]"
  'F5'        "$terminfo[kf5]"
  'F6'        "$terminfo[kf6]"
  'F7'        "$terminfo[kf7]"
  'F8'        "$terminfo[kf8]"
  'F9'        "$terminfo[kf9]"
  'F10'       "$terminfo[kf10]"
  'F11'       "$terminfo[kf11]"
  'F12'       "$terminfo[kf12]"
  'Backspace' "$terminfo[kbs]"
  'Insert'    "$terminfo[kich1]"
  'Home'      "$terminfo[khome]"
  'PageUp'    "$terminfo[kpp]"
  'Delete'    "$terminfo[kdch1]"
  'End'       "$terminfo[kend]"
  'PageDown'  "$terminfo[knp]"
  'Up'        "$terminfo[kcuu1]"
  'Left'      "$terminfo[kcub1]"
  'Down'      "$terminfo[kcud1]"
  'Right'     "$terminfo[kcuf1]"
  'BackTab'   "$terminfo[kcbt]"
)

# Displays the current vi mode.
function zle-line-init zle-line-finish zle-keymap-select {
  if [[ "$KEYMAP" == 'vicmd' ]]; then
    zstyle -s ':omz:prompt:vi' command 'vi_prompt_info'
  else
    zstyle -s ':omz:prompt:vi' insert 'vi_prompt_info'
  fi
  zle reset-prompt
  zle -R
}
zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

# Expands .... to ../..
function expand-dot-to-parent-directory-path {
  if [[ $LBUFFER = *.. ]]; then
    LBUFFER+='/..'
  else
    LBUFFER+='.'
  fi
}
zle -N expand-dot-to-parent-directory-path

# Displays an indicator when completing.
function expand-or-complete-with-indicator {
  local indicator
  zstyle -s ':omz:completion' indicator 'indicator'
  print -Pn "$indicator"
  zle expand-or-complete-prefix
  zle redisplay
}
zle -N expand-or-complete-with-indicator

# Inserts 'sudo ' at the beginning of the line.
function prepend-sudo {
  if [[ "$BUFFER" != su(do|)\ * ]]; then
    BUFFER="sudo $BUFFER"
    (( CURSOR += 5 ))
  fi
}
zle -N prepend-sudo

# Emacs key bindings.
[[ -n "$keyinfo[Escape]" ]] && \
  for key in "$keyinfo[Escape]"{B,b}; \
    bindkey -M emacs "$key" emacs-backward-word
[[ -n "$keyinfo[Escape]" ]] && \
  for key in "$keyinfo[Escape]"{F,f}; \
    bindkey -M emacs "$key" emacs-forward-word
[[ -n "$keyinfo[Escape]" && -n "$keyinfo[Left]" ]] && \
  bindkey -M emacs "$keyinfo[Escape]$keyinfo[Left]" emacs-backward-word
[[ -n "$keyinfo[Escape]" && -n "$keyinfo[Right]" ]] && \
  bindkey -M emacs "$keyinfo[Escape]$keyinfo[Right]" emacs-forward-word

# Kill to the beginning of the line.
[[ -n "$keyinfo[Escape]" ]] && \
  for key in "$keyinfo[Escape]"{K,k}; \
    bindkey -M emacs "$key" backward-kill-line

# Redo.
[[ -n "$keyinfo[Escape]" ]] && \
  bindkey -M emacs "$keyinfo[Escape]_" redo

# Search previous character.
[[ -n "$keyinfo[Control]" ]] && \
  bindkey -M emacs "$keyinfo[Control]X$keyinfo[Control]B" vi-find-prev-char

# Match bracket.
[[ -n "$keyinfo[Control]" ]] && \
  bindkey -M emacs "$keyinfo[Control]X$keyinfo[Control]]" vi-match-bracket

# Edit command in an external editor.
[[ -n "$keyinfo[Control]" ]] && \
  bindkey -M emacs "$keyinfo[Control]X$keyinfo[Control]E" edit-command-line

# Bind to the history substring search plugin if enabled;
# otherwise, bind to built-in Zsh history search.
if (( $+plugins[(er)history-substring-search] )); then
  [[ -n "$keyinfo[Control]" ]] && \
    bindkey -M emacs "$keyinfo[Control]P" history-substring-search-up
  [[ -n "$keyinfo[Control]" ]] && \
    bindkey -M emacs "$keyinfo[Control]N" history-substring-search-down
else
  [[ -n "$keyinfo[Control]" ]] && \
    bindkey -M emacs "$keyinfo[Control]P" up-line-or-history
  [[ -n "$keyinfo[Control]" ]] && \
    bindkey -M emacs "$keyinfo[Control]N" down-line-or-history
fi

if (( $+widgets[history-incremental-pattern-search-backward] )); then
  [[ -n "$keyinfo[Control]" ]] && \
    bindkey -M emacs "$keyinfo[Control]R" \
      history-incremental-pattern-search-backward
  [[ -n "$keyinfo[Control]" ]] && \
    bindkey -M emacs "$keyinfo[Control]S" \
      history-incremental-pattern-search-forward
else
  [[ -n "$keyinfo[Control]" ]] && \
    bindkey -M emacs "$keyinfo[Control]R" \
      history-incremental-search-backward
  [[ -n "$keyinfo[Control]" ]] && \
    bindkey -M emacs "$keyinfo[Control]S" \
      history-incremental-search-forward
fi

# Vi key bindings.

# Edit command in an external editor.
bindkey -M vicmd "v" edit-command-line

# Show cursor position.
bindkey -M vicmd "ga" what-cursor-position

# Undo/Redo
bindkey -M vicmd "u" undo
[[ -n "$keyinfo[Control]" ]] && \
  bindkey -M vicmd "$keyinfo[Control]R" redo

# Switch to command mode.
bindkey -M viins "jk" vi-cmd-mode
bindkey -M viins "kj" vi-cmd-mode

# History
bindkey -M vicmd "gg" beginning-of-history
bindkey -M vicmd "G" end-of-history

# Bind to the history substring search plugin if enabled;
# otherwise, bind to built-in Zsh history search.
if (( $+plugins[(er)history-substring-search] )); then
  bindkey -M vicmd "k" history-substring-search-up
  bindkey -M vicmd "j" history-substring-search-down
else
  bindkey -M vicmd "k" up-line-or-history
  bindkey -M vicmd "j" down-line-or-history
fi

if (( $+widgets[history-incremental-pattern-search-backward] )); then
  bindkey -M vicmd "?" history-incremental-pattern-search-backward
  bindkey -M vicmd "/" history-incremental-pattern-search-forward
else
  bindkey -M vicmd "?" history-incremental-search-backward
  bindkey -M vicmd "/" history-incremental-search-forward
fi

# Emacs and Vi key bindings.
for keymap in 'emacs' 'viins'; do
  [[ -n "$keyinfo[Home]" ]] && \
    bindkey -M "$keymap" "$keyinfo[Home]" beginning-of-line
  [[ -n "$keyinfo[End]" ]] && \
    bindkey -M "$keymap" "$keyinfo[End]" end-of-line

  [[ -n "$keyinfo[Insert]" ]] && \
    bindkey -M "$keymap" "$keyinfo[Insert]" overwrite-mode
  [[ -n "$keyinfo[Delete]" ]] && \
    bindkey -M "$keymap" "$keyinfo[Delete]" delete-char
  [[ -n "$keyinfo[Backspace]" ]] && \
    bindkey -M "$keymap" "$keyinfo[Backspace]" backward-delete-char && \
    stty erase "$keyinfo[Backspace]"

  [[ -n "$keyinfo[Left]" ]] && \
    bindkey -M "$keymap" "$keyinfo[Left]" backward-char
  [[ -n "$keyinfo[Right]" ]] && \
    bindkey -M "$keymap" "$keyinfo[Right]" forward-char

  # Expand history on space.
  bindkey -M "$keymap" ' ' magic-space

  if (( $+plugins[(er)history-substring-search] )); then
    [[ -n "$keyinfo[Up]" ]] && \
      bindkey -M "$keymap" "$keyinfo[Up]" history-substring-search-up
    [[ -n "$keyinfo[Down]" ]] && \
      bindkey -M "$keymap" "$keyinfo[Down]" history-substring-search-down
  else
    [[ -n "$keyinfo[Up]" ]] && \
      bindkey -M "$keymap" "$keyinfo[Up]" up-line-or-history
    [[ -n "$keyinfo[Down]" ]] && \
      bindkey -M "$keymap" "$keyinfo[Down]" down-line-or-history
  fi

  # Clear screen.
  [[ -n "$keyinfo[Control]" ]] && \
    bindkey -M "$keymap" "$keyinfo[Control]L" clear-screen

  # Expand command name to full path.
  [[ -n "$keyinfo[Escape]" ]] && \
    for key in "$keyinfo[Escape]"{E,e}; \
      bindkey -M "$keymap" "$key" expand-cmd-path

  # Duplicate the previous word.
  [[ -n "$keyinfo[Escape]" ]] && \
    for key in "$keyinfo[Escape]"{M,m}; \
      bindkey -M "$keymap" "$key" copy-prev-shell-word

  # Use a more flexible push-line.
  [[ -n "$keyinfo[Control]" && -n "$keyinfo[Escape]" ]] && \
    for key in "$keyinfo[Control]Q" "$keyinfo[Escape]"{q,Q}; \
      bindkey -M "$keymap" "$key" push-line-or-edit

  # Bind Shift + Tab to go to the previous menu item.
  [[ -n "$keyinfo[BackTab]" ]] && \
    bindkey -M "$keymap" "$keyinfo[BackTab]" reverse-menu-complete

  # Complete in the middle of word.
  [[ -n "$keyinfo[Control]" ]] && \
    bindkey -M "$keymap" "$keyinfo[Control]I" expand-or-complete-prefix

  # Expand .... to ../..
  if zstyle -t ':omz:editor' dot-expansion; then
    bindkey -M "$keymap" "." expand-dot-to-parent-directory-path
  fi

  # Display an indicator when completing.
  [[ -n "$keyinfo[Control]" ]] && \
    bindkey -M "$keymap" "$keyinfo[Control]I" \
      expand-or-complete-with-indicator

  # Insert 'sudo ' at the beginning of the line.
  [[ -n "$keyinfo[Control]" ]] && \
    bindkey -M "$keymap" "$keyinfo[Control]X$keyinfo[Control]S" prepend-sudo
done

# Do not expand .... to ../.. during incremental search.
if zstyle -t ':omz:editor' dot-expansion; then
  bindkey -M isearch . self-insert 2> /dev/null
fi

# Set the key layout.
zstyle -s ':omz:editor' keymap 'keymap'
if [[ "$keymap" == (emacs|) ]]; then
  bindkey -e
elif [[ "$keymap" == vi ]]; then
  bindkey -v
else
  print "omz: invalid keymap: $keymap" >&2
fi

unset keymap
unset key

