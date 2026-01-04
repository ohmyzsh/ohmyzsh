# zsh-vi-man plugin
# Smart man page lookup for zsh vi mode (now with emacs mode support!)
#
# Press K in vi normal mode, Ctrl-X k in emacs mode, or Ctrl-K in vi insert mode
# to open the man page for the current command. If your cursor is on an option
# (like -r or --recursive), it will jump directly to that option in the man page.
#
# https://github.com/TunaCuma/zsh-vi-man
# MIT License - Copyright (c) 2025 Tuna Cuma

# Configuration variables (can be set before sourcing)
# ZVM_MAN_KEY: the key to trigger man page lookup in vi normal mode (default: K)
# ZVM_MAN_KEY_EMACS: the key sequence for emacs mode (default: ^Xk, i.e., Ctrl-X k)
# ZVM_MAN_KEY_INSERT: the key for vi insert mode (default: ^K, i.e., Ctrl-K)
# ZVM_MAN_PAGER: the pager to use (default: less, supports nvim/vim)
# ZVM_MAN_ENABLE_EMACS: enable emacs mode binding (default: true)
# ZVM_MAN_ENABLE_INSERT: enable vi insert mode binding (default: true)

: ${ZVM_MAN_KEY:=K}
: ${ZVM_MAN_KEY_EMACS:='^Xk'}
: ${ZVM_MAN_KEY_INSERT:='^K'}
: ${ZVM_MAN_PAGER:=less}
: ${ZVM_MAN_ENABLE_EMACS:=true}
: ${ZVM_MAN_ENABLE_INSERT:=true}

# Get the directory where this script is located
typeset -g ZVM_LIB_DIR="${0:A:h}/lib"

# Source modular components
source "${ZVM_LIB_DIR}/parser.zsh"
source "${ZVM_LIB_DIR}/pattern.zsh"
source "${ZVM_LIB_DIR}/pager.zsh"
source "${ZVM_LIB_DIR}/keybinding.zsh"

# Main widget function - orchestrates the man page lookup
function zvm-man() {
  # Parse current context
  local word=$(zvm_parse_word_at_cursor)
  local cmd=$(zvm_parse_command)

  if [[ -z "$cmd" ]]; then
    zle -M "No command found"
    return 1
  fi

  # Determine the man page to open (may include subcommand)
  local current_segment=$(zvm_get_current_segment)
  local man_page=$(zvm_determine_man_page "$cmd" "$current_segment")

  # Clear screen and open man page with appropriate pager
  zle -I

  if ! zvm_open_man_page "$man_page" "$word"; then
    zle -M "No manual entry for ${man_page}"
  fi

  zle reset-prompt
}

# Register the widget
zle -N zvm-man

# Setup keybindings
zvm_setup_keybindings

