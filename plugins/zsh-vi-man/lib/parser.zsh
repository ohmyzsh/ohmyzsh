# lib/parser.zsh - Word and command parsing utilities
# Extracts words and commands from the command line buffer

# Get the word at the current cursor position
# Uses LBUFFER and RBUFFER which are ZLE special variables
zvm_parse_word_at_cursor() {
  local left="${LBUFFER##*[[:space:]]}"
  local right="${RBUFFER%%[[:space:]]*}"
  echo "${left}${right}"
}

# Get the current command segment (handles pipes)
# Returns the text after the last pipe before cursor
zvm_get_current_segment() {
  local segment="${LBUFFER##*|}"
  # Trim leading whitespace
  segment="${segment#"${segment%%[![:space:]]*}"}"
  echo "$segment"
}

# Extract the command name from a segment
# Takes the first word of the segment
zvm_parse_command() {
  local segment
  segment=$(zvm_get_current_segment)
  echo "${segment%%[[:space:]]*}"
}

# Determine the man page to open, checking for subcommands
# Input: $1 = command, $2 = current_segment
# Output: man page name (e.g., "git-commit" or just "git")
zvm_determine_man_page() {
  local cmd="$1"
  local segment="$2"
  local man_page="$cmd"

  local rest="${segment#*[[:space:]]}"
  local potential_subcommand="${rest%%[[:space:]]*}"

  # Check for subcommand man pages (e.g., git-commit, docker-run)
  if [[ -n "$potential_subcommand" && ! "$potential_subcommand" =~ ^- ]]; then
    if man -w "${cmd}-${potential_subcommand}" &>/dev/null; then
      man_page="${cmd}-${potential_subcommand}"
    fi
  fi

  echo "$man_page"
}

