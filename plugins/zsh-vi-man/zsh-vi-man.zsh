# zsh-vi-man.zsh -- Smart man page viewer for zsh vi mode
# https://github.com/TunaCuma/zsh-vi-man
#
# Press K in vi normal mode to open the man page for the current command.
# If your cursor is on an option (like -r or --recursive), it will jump
# directly to that option in the man page.
#
# MIT License - Copyright (c) 2025 Tuna Cuma

# Configuration variables (can be set before sourcing)
# ZVM_MAN_KEY: the key to trigger man page lookup (default: K)
# ZVM_MAN_PAGER: the pager to use (default: less)

: ${ZVM_MAN_KEY:=K}
: ${ZVM_MAN_PAGER:=less}

function zvm-man() {
  # Get the word at cursor position
  local left="${LBUFFER##*[[:space:]]}"
  local right="${RBUFFER%%[[:space:]]*}"
  local word="${left}${right}"
  
  # Find the current command segment (handles pipes: tree | grep -A)
  # Get everything after the last pipe before cursor
  local current_segment="${LBUFFER##*|}"
  # Trim leading whitespace
  current_segment="${current_segment#"${current_segment%%[![:space:]]*}"}"
  # Extract the command (first word of segment)
  local cmd="${current_segment%%[[:space:]]*}"
  
  if [[ -z "$cmd" ]]; then
    zle -M "No command found"
    return 1
  fi
  
  # Determine the man page to open
  local man_page="$cmd"
  local rest="${current_segment#*[[:space:]]}"
  local potential_subcommand="${rest%%[[:space:]]*}"
  
  # Check for subcommand man pages (e.g., git-commit, docker-run)
  if [[ -n "$potential_subcommand" && ! "$potential_subcommand" =~ ^- ]]; then
    if man -w "${cmd}-${potential_subcommand}" &>/dev/null; then
      man_page="${cmd}-${potential_subcommand}"
    fi
  fi
  
  # Build the search pattern for the current word
  # Patterns match option definitions: lines starting with whitespace then dash
  # Supports comma-separated (GNU style) and slash-separated (jq style) options
  local pattern=""
  if [[ -n "$word" ]]; then
    # Long option with value: --color=always -> search for --color
    if [[ "$word" =~ ^--[^=]+= ]]; then
      local opt="${word%%=*}"
      pattern="^[[:space:]]*${opt}([,/=:[[:space:]]|$)|^[[:space:]]*-.*[,/][[:space:]]+${opt}([,/=:[[:space:]]|$)"
    # Combined short options: -rf -> search for -[rf] to find individual options
    # Also includes fallback for single-dash long options like find's -name, -type
    elif [[ "$word" =~ ^-[a-zA-Z]{2,}$ ]]; then
      local chars="${word:1}"
      # Pattern 1: individual chars (e.g., -r or -f from -rf)
      # Pattern 2: the full word as-is (e.g., -name for find)
      pattern="^[[:space:]]*-[${chars}][,/:[:space:]]|^[[:space:]]*-.*[,/][[:space:]]+-[${chars}][,/:[:space:]]|^[[:space:]]*${word}([,/:[:space:]]|$)|^[[:space:]]*-.*[,/][[:space:]]+${word}([,/:[:space:]]|$)"
    # Single short option: -r -> match at start of option definition line
    elif [[ "$word" =~ ^-[a-zA-Z]$ ]]; then
      pattern="^[[:space:]]*${word}[,/:[:space:]]|^[[:space:]]*-.*[,/][[:space:]]+${word}([,/:[:space:]]|$)"
    # Long option without value: --recursive
    elif [[ "$word" =~ ^-- ]]; then
      pattern="^[[:space:]]*${word}([,/=:[[:space:]]|$)|^[[:space:]]*-.*[,/][[:space:]]+${word}([,/=:[[:space:]]|$)"
    fi
  fi
  
  # Clear screen and open man page
  zle -I
  
  if [[ -n "$pattern" ]]; then
    man "$man_page" 2>/dev/null | ${ZVM_MAN_PAGER} -p "${pattern}" 2>/dev/null || \
      man "$man_page" 2>/dev/null | ${ZVM_MAN_PAGER}
  else
    man "$man_page" 2>/dev/null || zle -M "No manual entry for ${man_page}"
  fi
  
  zle reset-prompt
}

# Register the widget and bind the key
zle -N zvm-man

function _zvm_man_bind_key() {
  bindkey -M vicmd "${ZVM_MAN_KEY}" zvm-man
}

# Support both immediate binding and lazy loading with zsh-vi-mode
if (( ${+functions[zvm_after_lazy_keybindings]} )); then
  # zsh-vi-mode is loaded with lazy keybindings, hook into it
  if [[ -z "${ZVM_LAZY_KEYBINDINGS}" ]] || [[ "${ZVM_LAZY_KEYBINDINGS}" == true ]]; then
    zvm_after_lazy_keybindings_commands+=(_zvm_man_bind_key)
  else
    _zvm_man_bind_key
  fi
elif (( ${+functions[zvm_after_init]} )); then
  # zsh-vi-mode without lazy keybindings
  zvm_after_init_commands+=(_zvm_man_bind_key)
else
  # Standalone or other vi-mode setups
  _zvm_man_bind_key
fi

