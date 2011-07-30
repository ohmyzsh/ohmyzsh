# Beep on error in line editor.
setopt beep

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

bindkey -d    # Reset to default key bindings.
bindkey -e    # Use Emacs key bindings.

# Do history expansion on space.
bindkey ' ' magic-space

# Avoid binding ^J, ^M,  ^C, ^?, ^S, ^Q, etc.
bindkey "${keys[Home]}"                 beginning-of-line
bindkey "${keys[End]}"                  end-of-line

bindkey "${keys[Insert]}"               overwrite-mode
bindkey "${keys[Delete]}"               delete-char

bindkey "${keys[Up]}"                   up-line-or-history
bindkey "${keys[Down]}"                 down-line-or-history

bindkey "${keys[Left]}"                 backward-char
bindkey "${keys[Right]}"                forward-char

bindkey "${keys[Meta]}b"                emacs-backward-word
bindkey "${keys[Meta]}f"                emacs-forward-word
bindkey "${keys[Escape]}${keys[Left]}"  emacs-backward-word
bindkey "${keys[Escape]}${keys[Right]}" emacs-forward-word

bindkey "${keys[Control]}w"             kill-region

bindkey "${keys[Escape]}e"              expand-cmd-path
bindkey "${keys[Escape]}m"              copy-prev-shell-word

bindkey '^[[Z'                          reverse-menu-complete       # Shift + Tab
bindkey "${keys[Control]}i"             expand-or-complete-prefix   # Complete in middle of word.

bindkey "${keys[Control]}_"             undo
bindkey "${keys[Escape]}_"              redo

# History
if autoloadable history-search-end; then
  autoload -U history-search-end
  zle -N history-beginning-search-backward-end history-search-end
  zle -N history-beginning-search-forward-end history-search-end
  bindkey "${keys[Control]}p" history-beginning-search-backward-end
  bindkey "${keys[Control]}n" history-beginning-search-forward-end
else
  bindkey "${keys[Control]}p" history-beginning-search-backward
  bindkey "${keys[Control]}n" history-beginning-search-forward
fi

if (( ${+widgets[history-incremental-pattern-search-backward]} )); then
  bindkey "${keys[Control]}r" history-incremental-pattern-search-backward
  bindkey "${keys[Control]}s" history-incremental-pattern-search-forward
else
  bindkey "${keys[Control]}r" history-incremental-search-backward
  bindkey "${keys[Control]}s" history-incremental-search-forward
fi

# Allow command line editing in an external editor.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "${keys[Control]}x${keys[Control]}e" edit-command-line

# Convert .... to ../.. automatically.
function rationalize-dot() {
  if [[ $LBUFFER = *.. ]]; then
    LBUFFER+=/..
  else
    LBUFFER+=.
  fi
}
zle -N rationalize-dot
bindkey '.' rationalize-dot
bindkey -M isearch . self-insert 2>/dev/null

