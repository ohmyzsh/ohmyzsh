# Code from Mikael Magnusson: https://www.zsh.org/mla/users/2011/msg00367.html
#
# Requires xterm, urxvt, iTerm2 or any other terminal that supports
# Bracketed Paste Mode as documented:
# https://www.xfree86.org/current/ctlseqs.html#Bracketed%20Paste%20Mode
#
# Additional technical details: https://cirw.in/blog/bracketed-paste

# Create a new keymap to use while pasting
bindkey -N paste
# Make everything in this new keymap enqueue characters for pasting
bindkey -RM paste '\x00-\xFF' paste-insert
# These are the codes sent around the pasted text in bracketed paste mode
# do the first one with both -M viins and -M vicmd in vi mode
bindkey '^[[200~' _start_paste
bindkey -M paste '^[[201~' _end_paste
# Insert newlines rather than carriage returns when pasting newlines
bindkey -M paste -s '^M' '^J'

zle -N _start_paste
zle -N _end_paste
zle -N paste-insert _paste_insert

# Attempt to not clobber zle_line_{init,finish}
# Use https://github.com/willghatch/zsh-hooks if available
if typeset -f hooks-add-hook > /dev/null; then
  hooks-add-hook zle_line_init_hook   _bracketed_paste_zle_init
  hooks-add-hook zle_line_finish_hook _bracketed_paste_zle_finish
else
  zle -N zle-line-init   _bracketed_paste_zle_init
  zle -N zle-line-finish _bracketed_paste_zle_finish
fi

# Switch the active keymap to paste mode
function _start_paste() {
  # Save the bindkey command to restore the active ("main") keymap
  # Tokenise the restorative bindkey command into an array
  _bracketed_paste_restore_keymap=( ${(z)"$(bindkey -lL main)"} )
  bindkey -A paste main
}

# Go back to our normal keymap, and insert all the pasted text in the
# command line. This has the nice effect of making the whole paste be
# a single undo/redo event.
function _end_paste() {
  # Only execute the restore command if it starts with 'bindkey'
  # Allow for option KSH_ARRAYS being set (indexing starts at 0)
  if [ ${_bracketed_paste_restore_keymap[@]:0:1} = 'bindkey' ]; then
    $_bracketed_paste_restore_keymap
  fi
  LBUFFER+=$_paste_content
  unset _paste_content _bracketed_paste_restore_keymap
}

function _paste_insert() {
  _paste_content+=$KEYS
}

function _bracketed_paste_zle_init() {
  _bracketed_paste_content=''
  # Tell terminal to send escape codes around pastes
  if [ $TERM =~ '^(rxvt-unicode|xterm(-256color)?|screen(-256color)?)$' ]; then
    printf '\e[?2004h'
  fi
}

function _bracketed_paste_zle_finish() {
  # Turn off bracketed paste when we leave ZLE, so pasting in other programs
  # doesn't get the ^[[200~ codes around the pasted text
  if [ $TERM =~ '^(rxvt-unicode|xterm(-256color)?|screen(-256color)?)$' ]; then
    printf '\e[?2004l'
  fi
}

