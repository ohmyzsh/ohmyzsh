# Kate admin helper

# Color definitions (standard and portable)
readonly RED="$(printf '\033[0;31m')"
readonly GREEN="$(printf '\033[0;32m')"
readonly YELLOW="$(printf '\033[1;33m')"
readonly RESET="$(printf '\033[0m')"

function kt_internal() {
  if [[ $# -eq 0 ]]; then
    echo -e "${RED}Usage: kt <file1> [file2 ...]${RESET}"
    return 1
  fi

  for file in "$@"; do
    local abs_path
    abs_path="$(realpath -m "$file")"

    if [[ -e "$file" ]]; then

      if [[ -w "$file" ]]; then
        echo -e "${GREEN}Opening '${file}' normally...${RESET}"
        command kate "$file"
      else
        echo -e "${YELLOW}No write permission for '${file}', opening with admin://...${RESET}"
        command kate "admin://${abs_path}"
      fi

    else
      local parent_dir
      parent_dir="$(dirname "$abs_path")"

      if [[ -w "$parent_dir" ]]; then
        echo -e "${GREEN}Opening new file '${file}' normally...${RESET}"
        command kate "$file"
      else
        cat <<END
${YELLOW}File '${file}' does not exist and no write permission for
directory '${parent_dir}', creating it with sudo...${RESET}
END

        if pkexec touch "$abs_path"; then
          echo -e "${GREEN}File '${file}' created successfully.${RESET}"
          command kate "admin://${abs_path}"
        else
          echo -e "${RED}Failed to create file '${file}'.${RESET}"
        fi
      fi

    fi
  done
}

# Allow kt command: calls the internal logic
function kt() {
  kt_internal "$@"
}

# Remove any previous alias for kate to avoid conflicts
unalias kate 2>/dev/null

# Allow kate command: uses the same internal logic as kt
# (Warning: overwriting standard 'kate' command.)
function kate() {
  kt_internal "$@"
}
