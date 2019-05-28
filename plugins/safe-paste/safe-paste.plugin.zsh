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
zle -N zle-line-init _zle_line_init
zle -N zle-line-finish _zle_line_finish
zle -N paste-insert _paste_insert

# Switch the active keymap to paste mode
function _start_paste() {
  bindkey -A paste main
}

# Go back to our normal keymap, and insert all the pasted text in the
# command line. This has the nice effect of making the whole paste be
# a single undo/redo event.
function _end_paste() {
#use bindkey -v here with vi mode probably. maybe you want to track
#if you were in ins or cmd mode and restore the right one.
  bindkey -e
  LBUFFER+=$_paste_content
  unset _paste_content
}

function _paste_insert() {
  _paste_content+=$KEYS
}

function _zle_line_init() {
  # Tell terminal to send escape codes around pastes
  if [ $TERM =~ '^(rxvt-unicode|xterm(-256color)?|screen(-256color)?)$' ]; then
    printf '\e[?2004h'
  fi
}

function _zle_line_finish() {
  # Turn off bracketed paste when we leave ZLE, so pasting in other programs
  # doesn't get the ^[[200~ codes around the pasted text
  if [ $TERM =~ '^(rxvt-unicode|xterm(-256color)?|screen(-256color)?)$' ]; then
    printf '\e[?2004l'
  fi
}

