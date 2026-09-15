PJ_DB=~/.pj_projects  # Project database file
touch "$PJ_DB"

_pj_help() {
  cat <<EOF
Project Jump (pj) - Quick directory navigation for projects

Usage:
  pj PROJECT_NAME             Jump to a project directory
  pj add [PATH] [NAME]        Add a project to registry. Defaults to current directory
  pj open [-e] (NAME ...)     Open project(s) in editor. Uses \$EDITOR (${EDITOR:-not set}) by default
  pj ls [PATTERN]             List all projects. Use PATTERN to filter results
  pj rm (PROJECT_NAME ...)    Remove project(s) from registry
  pj mv OLD_NAME NEW_NAME     Rename a project in registry
  pj help                     Show this help message

Examples:
  pj add                      # Add current directory
  pj add . my-project         # Add current directory as 'my-project'
  pj rm my-project            # Remove my-project from registry

  pj open my-project          # Open my-project in editor
  pj open my-project my-other # Open multiple projects
  pj open -e vim my-project   # Open my-project in nano. Specify editor with -e

  pj ls                       # List all projects
  pj ls my-project            # List projects matching 'my-project'
  pj ls 'subfolder/*my*'      # List projects matching 'subfolder/*my*'. Use quotes for globs

Aliases:
  pja - pj add
  pjo - pj open
  pjl - pj ls
EOF
}

_pj_jump() {
  local project_name="$1"
  local target_path

  # Check for extra arguments
  if [[ $# -gt 1 ]]; then
    echo "Error: Too many arguments" >&2
    echo "Usage: pj [PROJECT_NAME]" >&2
    return 1
  fi

  # Validate input
  if [[ -z "$project_name" ]]; then
    echo "Error: Missing project name" >&2
    echo "Usage: pj [PROJECT_NAME]" >&2
    return 1
  fi

  # Find project in database
  if [[ -f "$PJ_DB" ]]; then
    target_path=$(awk -F: -v project="$project_name" '
      $1 == project {print $2; exit}
    ' "$PJ_DB")
  fi

  # Handle found project
  if [[ -n "$target_path" ]]; then
    if [[ -d "$target_path" ]]; then
      cd "$target_path" || {
        echo "Error: Failed to access $target_path" >&2
        return 1
      }
      return 0
    else
      echo "Error: Path not exists for project '$project_name'" >&2
      echo "Path: $target_path" >&2
      return 1
    fi
  fi

  # Project not found
  echo "Error: Project not found - $project_name" >&2
  return 1
}

_pj_add() {
  local path_input=${1:-.}
  local name=${2:-}
  local resolved_path="${path_input:a}"
  local default_name="${resolved_path:t}"

  # Check for extra arguments
  if [[ $# -gt 2 ]]; then
    echo "Error: Too many arguments" >&2
    echo "Usage: pj add [PATH] [NAME]" >&2
    return 1
  fi

  # Check if the name is a command name
  case "$name" in
    add|rm|ls|open|mv|help)
      echo "Error: Invalid project name '$name'. It conflicts with a command name." >&2
      return 1
      ;;
  esac

  # Validate directory exists
  if [[ ! -d "$resolved_path" ]]; then
    echo "Error: Invalid directory path '$path_input'" >&2
    echo "Resolved to: $resolved_path" >&2
    return 1
  fi

  # Set default name if not provided
  if [[ -z "$name" ]]; then
    name="$default_name"
  fi

  # Validate name format
  if [[ "$name" =~ [^a-zA-Z0-9_-] ]]; then
    echo "Error: Invalid name '$name'" >&2
    echo "Allowed characters: A-Z, 0-9, -, _" >&2
    return 1
  fi

  # Check for existing project name
  if [[ -f "$PJ_DB" ]] && grep -q "^${name}:" "$PJ_DB"; then
    local existing_path=$(awk -F: -v n="$name" '$1 == n {print $2}' "$PJ_DB")
    echo "Error: Project name '$name' already exists" >&2
    echo "Existing path: $existing_path" >&2
    return 1
  fi

  # Add new entry
  echo "${name}:${resolved_path}" >> "$PJ_DB"
  echo "Added project: ${name} -> ${resolved_path}"
}

_pj_ls() {
  local pattern="${1:-*}"  # Default to all projects
  local -a projects=()
  local name path

  # Read database file
  while IFS=: read -r name path; do
    # Case-insensitive glob matching
    if [[ "${name:l}" == *${~pattern:l}* || \
          "${path:l}" == *${~pattern:l}* ]]; then
      projects+=("${name} -> ${path}")
    fi
  done < "$PJ_DB" 2>/dev/null

  # Process projects using Zsh built-ins
  if (( ${#projects} > 0 )); then
    # Remove duplicates and sort
    projects=(${(u)projects})  # Remove duplicates
    projects=(${(o)projects})  # Sort alphabetically

    # Print results
    print -l "${projects[@]}"
  fi
}

_pj_open() {
  local editor="$EDITOR"
  local project_names=()
  local target_path
  local errors=0

  # Parse options
  while [[ "$1" =~ ^- ]]; do
    case "$1" in
      -e|--editor)
        shift
        editor="$1"
        ;;
      *)
        echo "Error: Invalid option $1" >&2
        echo "Usage: pj open [-e editor] (PROJECT_NAME ...)" >&2
        return 1
        ;;
    esac
    shift
  done

  # Collect project names
  project_names=("$@")

  # Validate input
  if [[ ${#project_names[@]} -eq 0 ]]; then
    echo "Error: Missing project name(s)" >&2
    echo "Usage: pj open [-e editor] [PROJECT_NAME ...]" >&2
    return 1
  fi

  # Validate editor
  if [[ -z "$editor" ]]; then
    echo "Error: No editor specified" >&2
    echo "Set \$EDITOR or use -e option" >&2
    return 1
  fi

  for project_name in "${project_names[@]}"; do
    # Find project in database
    target_path=$(awk -F: -v project="$project_name" '$1 == project {print $2; exit}' "$PJ_DB")

    # Handle project path
    if [[ -n "$target_path" ]]; then
      if [[ -d "$target_path" ]]; then
        ${=editor} "$target_path"
      else
        echo "Error: Invalid path for project '$project_name'" >&2
        echo "Path: $target_path" >&2
        errors=$((errors + 1))
      fi
    else
      echo "Error: Project not found - $project_name" >&2
      errors=$((errors + 1))
    fi
  done

  return $errors
}

_pj_rm() {
  local project_names=("$@")
  local errors=0

  # Validate input
  if [[ ${#project_names[@]} -eq 0 ]]; then
    echo "Error: Missing project name(s)" >&2
    echo "Usage: pj rm [PROJECT_NAME ...]" >&2
    return 1
  fi

  for project_name in "${project_names[@]}"; do
    # Verify project exists
    if ! grep -q "^${project_name}:" "$PJ_DB"; then
      echo "Error: Project not found - $project_name" >&2
      errors=$((errors + 1))
      continue
    fi

    # Remove entry from database
    local project_path=$(awk -F: -v project="$project_name" '$1 == project {print $2; exit}' "$PJ_DB")
    sed -i.bak "/^${project_name}:/d" "$PJ_DB" && rm -f "$PJ_DB.bak"
    echo "Removed project: $project_name -> $project_path"
  done

  return $errors
}

_pj_mv() {
  local project_name="$1"
  local new_name="$2"

  # Validate input
  if [[ -z "$project_name" || -z "$new_name" ]]; then
    echo "Error: Missing project name or new name" >&2
    echo "Usage: pj mv [PROJECT_NAME] [NEW_NAME]" >&2
    return 1
  fi

  # Verify project exists
  if ! grep -q "^${project_name}:" "$PJ_DB"; then
    echo "Error: Project not found - $project_name" >&2
    return 1
  fi

  # Verify new name is not taken
  if grep -q "^${new_name}:" "$PJ_DB"; then
    echo "Error: New project name already exists - $new_name" >&2
    return 1
  fi

  # Move project
  sed -i.bak "s/^${project_name}:/${new_name}:/g" "$PJ_DB" && rm -f "$PJ_DB.bak"
  echo "Moved project: $project_name -> $new_name"
}

# Main function
function pj() {
  if [ $# -eq 0 ]; then
    _pj_help
    return 1
  fi

  # Command dispatch
  case "$1" in
    "add")
      shift  # Remove 'add' from arguments
      _pj_add "$@"
      ;;
    "rm")
      shift
      _pj_rm "$@"
      ;;
    "ls")
      shift
      _pj_ls "$@"
      ;;
    "open")
      shift
      _pj_open "$@"
      ;;
    "mv")
      shift
      _pj_mv "$@"
      ;;
    "help"|"--help"|"-h"|"")
      _pj_help
      return 1
      ;;
    *)
      _pj_jump "$@"
      ;;
  esac
}

# Main completion entry point
_pj() {
  local context state state_descr line
  typeset -A opt_args

  # Parse command line state
  _arguments -C \
    '1: :->command_or_project' \
    '*: :->args'

  case $state in
    (command_or_project)
      _pj_show_projects
      ;;
    (args)
      _pj_handle_subcommand_args
      ;;
  esac
}

# Helper: Handle arguments after subcommand
_pj_handle_subcommand_args() {
  case $line[1] in
    (add)
      _files -/
      ;;

    (open|rm|ls|mv)
      _pj_show_projects
      ;;
  esac
}

# Helper: Show just project names
_pj_show_projects() {
  local projects=(${(f)"$(cut -d: -f1 "$PJ_DB" 2>/dev/null)"})
  _describe 'projects' projects
}

# Register completion
compdef _pj pj

# Editor aliases
alias pja="pj add"
alias pjo="pj open"
alias pjl="pj ls"
