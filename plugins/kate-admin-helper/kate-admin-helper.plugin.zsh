# Kate admin helper

# Color definitions (standard and portable)
RED="$(printf '\033[0;31m')"
GREEN="$(printf '\033[0;32m')"
YELLOW="$(printf '\033[1;33m')"
RESET="$(printf '\033[0m')"

kt_internal() {
  if [[ $# -eq 0 ]]; then
    echo -e "${RED}Usage: kt <file1> [file2 ...]${RESET}"
    return 1
  fi

  for file in "$@"; do
    local abs_path
    abs_path="$(realpath -m "$file")"

    if [[ -e "$file" ]]; then
      # File exists
      if [[ -w "$file" ]]; then
        echo -e "${GREEN}Opening '$file' normally...${RESET}"
        command kate "$file"
      else
        echo -e "${YELLOW}No write permission for '$file', opening with admin://...${RESET}"
        command kate "admin://$abs_path"
      fi
    else
      # File does not exist, check parent directory
      local parent_dir
      parent_dir="$(dirname "$abs_path")"

      if [[ -w "$parent_dir" ]]; then
        echo -e "${GREEN}Opening new file '$file' normally...${RESET}"
        command kate "$file"
      else
        echo -e "${YELLOW}File '$file' does not exist and no write permission for directory '$parent_dir', creating it with sudo...${RESET}"
        if pkexec touch "$abs_path"; then
          echo -e "${GREEN}File '$file' created successfully.${RESET}"
          command kate "admin://$abs_path"
        else
          echo -e "${RED}Failed to create file '$file'.${RESET}"
        fi
      fi
    fi
  done
}

# Allow kt command: calls the internal logic
kt() {
  kt_internal "$@"
}

# Allow kate command: uses the same internal logic as kt
kate() {
  kt_internal "$@"
}

# Remove any previous alias for kate to avoid conflicts
unalias kate 2>/dev/null
