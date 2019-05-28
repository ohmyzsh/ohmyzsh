# A good summary of the zsh 5.1 Bracketed Paste Mode changes is at:
# https://archive.zhimingwang.org/blog/2015-09-21-zsh-51-and-bracketed-paste.html

# zsh 5.1 (September 2015) introduced built-in support for Bracketed Paste Mode
# https://github.com/zsh-users/zsh/blob/68405f31a043bdd5bf338eb06688ed3e1f740937/README#L38-L45
#
# zsh 5.1 breaks url-quote-magic and other widgets replacing self-insert
# zsh-users' bracketed-paste-magic resolves these issues:
# https://github.com/zsh-users/zsh/blob/f702e17b14d75aa21bff014168fa9048124db286/Functions/Zle/bracketed-paste-magic#L9-L12

# Load bracketed-paste-magic if zsh version is >= 5.1
if [[ ${ZSH_VERSION:0:3} -ge 5.1 ]]; then
  set zle_bracketed_paste  # Explicitly restore this zsh default
  autoload -Uz bracketed-paste-magic
  zle -N bracketed-paste bracketed-paste-magic
  return  ### The rest of this file is NOT executed on zsh version >= 5.1 ###
fi

######################################################################
#    The rest of this file is ONLY executed if zsh version < 5.1
######################################################################

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

