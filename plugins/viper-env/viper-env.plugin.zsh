# Colors based on:
# https://www.lihaoyi.com/post/BuildyourownCommandLinewithANSIescapecodes.html#16-colors
export COLOR_BLACK=$'\033[0;30m'
export COLOR_BRIGHT_BLACK=$'\u001b[30;1m'
export COLOR_RED=$'\033[0;31m'
export COLOR_BRIGHT_RED=$'\u001b[31;1m'
export COLOR_GREEN=$'\033[0;32m'
export COLOR_BRIGHT_GREEN=$'\u001b[32;1m'
export COLOR_YELLOW=$'\033[0;33m'
export COLOR_BRIGHT_YELLOW=$'\u001b[33;1m'
export COLOR_BLUE=$'\033[0;34m'
export COLOR_BRIGHT_BLUE=$'\u001b[34;1m'
export COLOR_VIOLET=$'\033[0;35m'
export COLOR_BRIGHT_VIOLET=$'\u001b[35;1m'
export COLOR_CYAN=$'\033[0;36m'
export COLOR_BRIGHT_CYAN=$'\u001b[36;1m'
export COLOR_WHITE=$'\033[0;37m'
export COLOR_BRIGHT_WHITE=$'\u001b[37;1m'
export COLOR_NC=$'\033[0m' # No Color

# Configuration file for persistent settings.
_VIPER_ENV_CONFIG_FILE="$HOME/.viper-env.conf"
_VIPER_ENV_VERSION="v1.1.0"

# This variable will hold the path of the environment managed by this script.
# This prevents us from deactivating environments managed by other tools (e.g., conda, poetry).
_VIPER_ENV_MANAGED_PATH=""

# This variable tracks if a user manually runs `deactivate` in a directory,
# to prevent immediate re-activation by the precmd hook.
# These variables prevent the same warning from being printed multiple times.
_VIPER_ENV_LAST_WARNING_KEY=""
_VIPER_ENV_LAST_PWD="$PWD"

# Discovers a virtual environment by searching upwards from the current directory.
# This function is the core of the discovery logic.
__viper-env_discover_venv() {
  # Use `emulate` to ensure a predictable environment and `dotglob` to find hidden venvs.
  emulate -L zsh
  setopt local_options dotglob
  local search_dir="$PWD"
  # Loop upwards from the current directory to the root.
  while :; do
    # Mode 1: Semi-automatic via `.viper-env` file
    # This allows using virtual environments located outside the project directory.
    if [[ -f "$search_dir/.viper-env" ]]; then
      local external_venv_path
      # Read the path from the file, handling potential trailing newlines.
      # Using 'read -r' is more robust for reading a single line from a file.
      read -r external_venv_path < "$search_dir/.viper-env"
      # Remove trailing carriage return if file has Windows line endings.
      external_venv_path=${external_venv_path%$'\r'}
      # Perform tilde expansion on the path to support paths like ~/.virtualenvs/...
      external_venv_path=${(~)external_venv_path}

      # The path in the file can be either the venv root or the full path to the activate script.
      # This logic handles both cases robustly.
      local venv_root_path=""
      if [[ "$external_venv_path" == */bin/activate && -f "$external_venv_path" ]]; then
        # Case 1: Path is the full path to the activate script.
        venv_root_path="$(dirname "$(dirname "$external_venv_path")")"
      elif [[ -f "$external_venv_path/bin/activate" ]]; then
        # Case 2: Path is the root of the virtual environment.
        venv_root_path="$external_venv_path"
      fi

      if [[ -n "$venv_root_path" ]]; then
        echo "$venv_root_path"
        return 0
      else
        # If the file exists but the path is invalid, print a warning to stderr
        # and continue searching. This prevents the script from failing silently.
        local warning_key="$search_dir:$external_venv_path"
        if [[ "$_VIPER_ENV_LAST_WARNING_KEY" != "$warning_key" ]]; then
          printf "${COLOR_YELLOW}viper-env: Warning: Found '%s' but the path inside ('%s') is not a valid virtual environment. Ignoring.${COLOR_NC}\n" "$search_dir/.viper-env" "$external_venv_path" >&2
          _VIPER_ENV_LAST_WARNING_KEY="$warning_key"
        fi
      fi
    fi

    # Pattern 1: Check if the search_dir itself is a venv root.
    if [[ -f "$search_dir/bin/activate" ]]; then
      echo "$search_dir"
      return 0
    fi

    # Pattern 2: Check for a venv in an immediate subdirectory.
    # The `(N[1])` glob qualifier finds the first match and prevents errors if none exist.
    local activate_script=($search_dir/*/bin/activate(N[1]))
    if [[ -n "$activate_script" ]]; then
      echo "$(dirname $(dirname "$activate_script"))"
      return 0
    fi

    # Exit if we've reached the root directory, otherwise, go up one level.
    [[ "$search_dir" == "/" ]] && break
    search_dir=$(dirname "$search_dir")
  done
  return 1
}

__viper-env_activate() {
  local venv_path="$1"
  if [[ -z "$venv_path" ]]; then return 1; fi

  if [[ -z "$VIPER_ENV_QUIET" ]]; then
    # Use OLDPWD for cd, but PWD for venv creation. Fallback to PWD if OLDPWD is not set.
    local relative_to_dir="${OLDPWD:-$PWD}"
    local activating_path
    activating_path=$(realpath --relative-to="$relative_to_dir" "$venv_path" 2>/dev/null || basename "$venv_path")
    echo "Activating virtual environment ${COLOR_BRIGHT_VIOLET}$activating_path${COLOR_NC}"
  fi
  source "$venv_path/bin/activate"
  _VIPER_ENV_MANAGED_PATH="$VIRTUAL_ENV"
  # Wrap the 'deactivate' command to keep our state in sync on manual deactivation.
  alias deactivate='__viper-env_manual_deactivate'
}

__viper-env_manual_activate() {
    # This function is called by the 'activate' alias for manual activation.
    local discovered_path
    discovered_path=$(__viper-env_discover_venv)
    if [[ -n "$discovered_path" ]]; then
        # Call the main activation logic.
        __viper-env_activate "$discovered_path"
    else
        # This case is unlikely if the alias logic is correct, but good for robustness.
        printf "${COLOR_RED}Error: No virtual environment found to activate.${COLOR_NC}\n" >&2
        # We should also remove the alias if it somehow exists erroneously.
        unalias activate 2>/dev/null
        return 1
    fi
}

__viper-env_manage_activate_alias() {
  local venv_path="$1"
  # If a venv is discovered AND it's not already the active one, create an alias.
  # Otherwise, remove it. This keeps the 'activate' command clean and available
  # only when it's contextually relevant.
  [[ -n "$venv_path" && "$venv_path" != "$VIRTUAL_ENV" ]] && alias activate='__viper-env_manual_activate' || unalias activate 2>/dev/null
}

__viper-env_manual_deactivate() {
  # Unset our internal state *before* calling the original deactivate.
  # This prevents race conditions with hooks that might run.
  _VIPER_ENV_MANAGED_PATH=""

  # Remove the alias to prevent loops and restore default behavior.
  unalias deactivate 2>/dev/null

  # Call the original 'deactivate' function if it exists.
  # It will handle unsetting VIRTUAL_ENV, restoring PATH, and unsetting itself.
  command -v deactivate >/dev/null 2>&1 && deactivate

  # After deactivation, we must re-evaluate the state to recreate the 'activate' alias if needed.
  # This is crucial because no other hook will run without a directory change.
  __viper-env_sync_state
}

__viper-env_deactivate() {
  local reason="$1"
  local deactivating_path
  deactivating_path=$(realpath --relative-to="$PWD" "$_VIPER_ENV_MANAGED_PATH" 2>/dev/null || basename "$_VIPER_ENV_MANAGED_PATH")

  if [[ -z "$VIPER_ENV_QUIET" ]]; then
    local reason_text=""
    [[ "$reason" == "defunct" ]] && reason_text="defunct "
    echo "Deactivating ${reason_text}virtual environment ${COLOR_BRIGHT_VIOLET}$deactivating_path${COLOR_NC}"
  fi

  # Manually perform the core actions of a venv's 'deactivate' function.
  # This is more robust than relying on an external function that might be
  # missing or interfered with by other plugins, which causes the
  # 'command not found: deactivate' error.

  # 1. Restore the original PATH. The 'activate' script saves this for us.
  if [[ -n "$_OLD_VIRTUAL_PATH" ]]; then
    export PATH="$_OLD_VIRTUAL_PATH"
    unset _OLD_VIRTUAL_PATH
  fi

  # 2. Unset the VIRTUAL_ENV variable. This is the most critical step.
  unset VIRTUAL_ENV
  _VIPER_ENV_MANAGED_PATH=""
  # Also remove our alias wrapper when deactivating automatically.
  unalias deactivate 2>/dev/null
}

# This is the central logic function that synchronizes the shell state with the directory state.
# It's called by both chpwd and precmd hooks.
__viper-env_sync_state() {
  local local_venv_path
  local_venv_path=$(__viper-env_discover_venv)
  __viper-env_manage_activate_alias "$local_venv_path"

  # --- Defunct venv check (always active) ---
  # If a viper-env managed venv is active and has been deleted, we should
  # always clean up the shell state to prevent confusion, regardless of autoload settings.
  if [[ -n "$_VIPER_ENV_MANAGED_PATH" && ! -d "$_VIPER_ENV_MANAGED_PATH" ]]; then
    __viper-env_deactivate "defunct"
    return # State is now clean, nothing more to do.
  fi

  # --- Automatic Activation/Deactivation Logic ---
  # This entire block only runs if autoload is enabled.
  if [[ "$(__viper-env_get_hook_type)" == "precmd" ]]; then
    # --- Deactivation on leaving ---
    # If a managed venv is active and we are in a directory that has a different venv or no venv...
    if [[ -n "$_VIPER_ENV_MANAGED_PATH" && "$_VIPER_ENV_MANAGED_PATH" != "$local_venv_path" ]]; then
      __viper-env_deactivate "leaving"
    fi

    # --- Activation on entering ---
    # If a local venv is discovered and it's not the currently active one...
    if [[ -n "$local_venv_path" && "$VIRTUAL_ENV" != "$local_venv_path" ]]; then
      __viper-env_activate "$local_venv_path"
    fi
  fi
}

# Hook for directory changes.
__viper-env_on_chpwd() {
  # Reset the warning suppression key if the directory has changed.
  if [[ "$_VIPER_ENV_LAST_PWD" != "$PWD" ]]; then
    _VIPER_ENV_LAST_WARNING_KEY=""
    _VIPER_ENV_LAST_PWD="$PWD"
  fi

  # When using the chpwd hook, we sync state on every directory change.
  # This check prevents sync_state from running twice when precmd is also active,
  # as chpwd runs before precmd on a directory change.
  [[ "$(__viper-env_get_hook_type)" == "chpwd" ]] && __viper-env_sync_state
}

# Hook that runs after every command.
__viper-env_on_precmd() {
  # This hook only runs if enabled. Its only job is to sync state.
  __viper-env_sync_state
}

# Reads the configured hook type from the config file. Defaults to 'chpwd'.
__viper-env_get_hook_type() {
  local hook_type="precmd" # Default
  if [[ -f "$_VIPER_ENV_CONFIG_FILE" ]]; then
    # A simple grep is safer than sourcing the file.
    if grep -q '^_VIPER_ENV_HOOK_TYPE="chpwd"$' "$_VIPER_ENV_CONFIG_FILE"; then
      hook_type="chpwd"
    fi
  fi
  echo "$hook_type"
}

# Registers the appropriate hook based on the configuration.
__viper-env_register_hook() {
  # Remove any existing hooks to prevent duplicates or conflicts.
  add-zsh-hook -d chpwd __viper-env_on_chpwd
  add-zsh-hook -d precmd __viper-env_on_precmd

  # The chpwd hook is always active to handle directory changes and reset state.
  add-zsh-hook chpwd __viper-env_on_chpwd

  # The precmd hook is optional, for immediate activation on venv creation.
  local hook_type
  hook_type=$(__viper-env_get_hook_type)
  if [[ "$hook_type" == "precmd" ]]; then
    add-zsh-hook precmd __viper-env_on_precmd
  fi
}

autoload -Uz add-zsh-hook
# Register the appropriate hook based on the user's configuration.
__viper-env_register_hook

__viper-env_update_config_and_reload() {
  local message="$1"
  local config_line="$2"
  echo -e "$message"
  echo "$config_line" > "$_VIPER_ENV_CONFIG_FILE"
  __viper-env_register_hook
}

__viper-env_handle_autoload() {
  case "$1" in
    --enable)
      __viper-env_update_config_and_reload "Enabling automatic virtual environment activation." '_VIPER_ENV_HOOK_TYPE="precmd"'
      ;;
    --disable)
      __viper-env_update_config_and_reload "Disabling automatic virtual environment activation.\nUse 'activate' for manual activation." '_VIPER_ENV_HOOK_TYPE="chpwd"'
      ;;
    *)
      cat >&2 <<EOF
${COLOR_RED}Error: Unknown argument '$1' for autoload command.${COLOR_NC}

Usage: viper-env autoload [--enable|--disable]
  --enable:  Automatically activate and deactivate virtual environments (default).
  --disable: Disables all automatic activation and deactivation. Manual control is required via 'activate'.
EOF
      return 1
      ;;
  esac
}
# Provides the help text for the plugin.
# Using a HEREDOC for a cleaner, multi-line string.
__viper-env_help() {
  cat <<EOF
Description:
  ${COLOR_BRIGHT_BLACK}Automatically activates and deactivates python virtualenv upon cd in and out.${COLOR_NC}

Dependencies:
  ${COLOR_BRIGHT_BLACK}- zsh
  - python${COLOR_NC}

Example usage:
  ${COLOR_BRIGHT_BLACK}# Create new project folder${COLOR_NC}
  ${COLOR_BRIGHT_GREEN}mkdir${COLOR_NC} new_project
  ${COLOR_BRIGHT_BLACK}# Create virtual environment${COLOR_NC}
  ${COLOR_BRIGHT_GREEN}python${COLOR_NC} -m venv .venv
  ${COLOR_BRIGHT_BLACK}# Exit current directory${COLOR_NC}
  ${COLOR_BRIGHT_GREEN}cd${COLOR_NC} ..
  ${COLOR_BRIGHT_BLACK}# Reenter it${COLOR_NC}
  ${COLOR_GREEN}cd${COLOR_NC} new_project

Manual Activation:
  When a virtual environment is discovered and not yet active, you can manually
  activate it by simply running:
  ${COLOR_BRIGHT_GREEN}activate${COLOR_NC}
  This command is an alias that is automatically created and removed by viper-env.
  It is especially useful when autoloading is disabled.

Commands:
  ${COLOR_BRIGHT_GREEN}help, h${COLOR_NC}      Show this help message.
  ${COLOR_BRIGHT_GREEN}list${COLOR_NC}         Show the currently active virtual environment.
  ${COLOR_BRIGHT_GREEN}status${COLOR_NC}       Show detailed status for debugging.
  ${COLOR_BRIGHT_GREEN}autoload${COLOR_NC}     Configure the activation hook (--enable|--disable).
  ${COLOR_BRIGHT_GREEN}version, --version${COLOR_NC} Show the plugin version.
EOF
}

# Renders a title and key-value pairs as a formatted table.
# The function dynamically calculates column widths for alignment.
__viper-env_draw_table() {
  local title="$1"
  shift
  local -a data=("$@")
  local -a keys values rows
  local i

  # Separate keys and values from the input array.
  for (( i=1; i<=${#data[@]}; i+=2 )); do
    keys+=("${data[i]}")
    values+=("${data[i+1]}")
  done

  local max_key_width=0
  for key in "${keys[@]}"; do
    [[ ${#key} -gt $max_key_width ]] && max_key_width=${#key}
  done

  # Build the formatted rows in memory using parameter expansion for efficiency.
  for (( i=1; i<=${#keys[@]}; i++ )); do
    rows+=("${(r:max_key_width:: :)keys[i]}: ${values[i]}")
  done

  # --- Calculate table dimensions ---
  local max_width=0
  local clean_row
  # Enable extended globbing for pattern matching ANSI codes.
  emulate -L zsh; setopt extended_glob
  for row in "${rows[@]}"; do
    clean_row=${row//(#m)$'\e'\[[0-9;]#m/}
    [[ ${#clean_row} -gt $max_width ]] && max_width=${#clean_row}
  done

  local clean_title=${title//(#m)$'\e'\[[0-9;]#m/}
  local title_len=${#clean_title}
  [[ $max_width -lt $title_len ]] && max_width=$title_len

  # --- Render the table with a single, final I/O call ---
  local padding=$(( (max_width - title_len) / 2 ))
  local underline="${(r:$max_width::-:)}"

  # Build the format string and arguments array for a single, robust printf call.
  local -a fmts args

  # Header
  fmts+=("%*s%s\n%s\n")
  args+=($padding "" "$title" "$underline")

  # Body
  for row in "${rows[@]}"; do
    fmts+=("%s\n")
    args+=("$row")
  done

  # Combine formats into a single string using Zsh's parameter expansion `(j::)` flag.
  local format_string="${(j::)fmts}"

  # Render the entire table with one I/O call.
  printf -- "$format_string" "${args[@]}"
}

# We unalias first to prevent "defining function based on alias" errors
# if the script is sourced multiple times in the same session.
unalias viper-env 2>/dev/null
viper-env() {
  case "$1" in
    "" | "h" | "help")
      __viper-env_help
      ;;
    "version" | "--version")
      printf "viper-env version %s\n" "$_VIPER_ENV_VERSION"
      ;;
    "list")
      local list_status
      if [[ -n "$VIRTUAL_ENV" ]]; then
        list_status="Active virtual environment: ${COLOR_BRIGHT_GREEN}${VIRTUAL_ENV}${COLOR_NC}"
      else
        list_status="No virtual environment is currently active."
      fi
      printf "%s\n" "$list_status"
      ;;
    "status")
      local -a table_data

      # Row 1: PWD
      table_data+=("PWD" "$PWD")

      # Row 2: Active Venv
      local venv_value venv_color
      if [[ -n "$VIRTUAL_ENV" ]]; then
        venv_value="$VIRTUAL_ENV"
        venv_color="$COLOR_BRIGHT_GREEN"
      else
        venv_value="Not set"
        venv_color="$COLOR_RED"
      fi
      table_data+=("Active Venv" "${venv_color}${venv_value}${COLOR_NC}")

      # Row 3: Managed Path
      local managed_path_value managed_path_color
      if [[ -n "$_VIPER_ENV_MANAGED_PATH" ]]; then
        managed_path_value="$_VIPER_ENV_MANAGED_PATH"
        managed_path_color="$COLOR_BRIGHT_GREEN"
      else
        managed_path_value="Not set"
        managed_path_color="$COLOR_RED"
      fi
      table_data+=("Managed Path" "${managed_path_color}${managed_path_value}${COLOR_NC}")

      # Row 4: Hook Type
      table_data+=("Hook Type" "${COLOR_BRIGHT_CYAN}$(__viper-env_get_hook_type)${COLOR_NC}")

      # Row 5: Discovered Venv
      local discovered_path
      discovered_path=$(__viper-env_discover_venv)
      local discovered_value discovered_color
      if [[ -n "$discovered_path" ]]; then
        discovered_value="$discovered_path"
        discovered_color="$COLOR_BRIGHT_CYAN"
      else
        discovered_value="None"
        discovered_color="" # No color
      fi
      table_data+=("Discovered Venv" "${discovered_color}${discovered_value}${COLOR_NC}")

      # Row 6: Activation Cmd
      local activation_value activation_color
      if alias activate >/dev/null 2>&1; then
        if [[ "$(alias activate)" == *__viper-env_manual_activate* ]]; then
          activation_value="'activate' alias is set by viper-env"
          activation_color="$COLOR_BRIGHT_GREEN"
        else
          activation_value="'activate' alias is set by another tool"
          activation_color="$COLOR_YELLOW"
        fi
      else
        activation_value="'activate' alias is not set"
        activation_color="$COLOR_RED"
      fi
      table_data+=("Activation Cmd" "${activation_color}${activation_value}${COLOR_NC}")

      local title="${COLOR_BRIGHT_WHITE}Viper-Env Status${COLOR_NC}"
      __viper-env_draw_table "$title" "${table_data[@]}"
      ;;
    "autoload")
      __viper-env_handle_autoload "$2"
      ;;
    *)
      cat >&2 <<EOF
${COLOR_RED}Error: Unknown command '$1'${COLOR_NC}

EOF
      __viper-env_help
      return 1
      ;;
  esac
}
