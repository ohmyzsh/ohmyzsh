# Specific key bindings
# See also key-binding-support.zsh for helper functions used here

bindkey -e                                            # Use emacs key bindings

omz_bindkey    '\ew' kill-region                      # [Esc-w] - Kill from the cursor to the mark
omz_bindkey -s '\el' 'ls\n'                           # [Esc-l] - run command: ls
omz_bindkey    '^r' history-incremental-search-backward  # [Ctrl-r] - Search backward incrementally for a specified string. 
                                                      #    The string may begin with ^ to anchor the search to the beginning of the line.

omz_bindkey -t kpp    up-line-or-history            # [PageUp] - Up a line of history
omz_bindkey -t knp    down-line-or-history          # [PageDown] - Down a line of history
omz_bindkey -t kcuu1  up-line-or-search             # start typing + [Up-Arrow] - fuzzy find history forward
omz_bindkey -t kcud1  down-line-or-search           # start typing + [Down-Arrow] - fuzzy find history backward
omz_bindkey -t khome  beginning-of-line             # [Home] - Go to beginning of line
omz_bindkey -t kend   end-of-line                   # [End] - Go to end of line
omz_bindkey -c ctrl right  forward-word             # [Ctrl-Right] - move forward one word
omz_bindkey -c ctrl left   backward-word            # [Ctrl-Left] - move backward one word
  
omz_bindkey    ' '    magic-space                   # [Space] - do history expansion

omz_bindkey -t kcbt   reverse-menu-complete         # [Shift-Tab] - move through the completion menu backwards

omz_bindkey    '^?'   backward-delete-char          # [Backspace] - delete backward
omz_bindkey -t kdch1  delete-char                   # [Delete] - delete forward
if [[ $? != 0 ]]; then
  # Alternate forward-delete sequences, if not in terminfo
  omz_bindkey '\e[3~'  delete-char   # VT220 editing keypad Del
  omz_bindkey '\e3;5~' delete-char   # I don't know what this is, but it was here before -apjanke
fi

# Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
omz_bindkey '\C-x\C-e' edit-command-line

# File rename magick
omz_bindkey '\em' copy-prev-shell-word

