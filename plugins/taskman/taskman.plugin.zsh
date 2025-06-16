#!/usr/bin/env zsh
#
# Terminal Task Manager Plugin for Oh-My-Zsh
# A powerful sidebar-style task manager that runs entirely in your terminal
#
# Author: @oiahoon
# Version: 2.0.0
# Repository: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/taskman
#
# Features:
# - Interactive terminal UI with keyboard shortcuts
# - Command line interface for quick operations
# - Priority system with color coding
# - Persistent JSON storage with configurable location
# - Vim-like keybindings
# - Multiple sorting modes with completed tasks at bottom
# - Color-coded bullets with neutral task text
# - Zero external dependencies (Python 3 only)
#

# Plugin directory detection (Oh-My-Zsh compatible)
TASKMAN_PLUGIN_DIR="${0:h}"

# Data directory (store tasks in home directory)
TASKMAN_DATA_DIR="$HOME/.taskman"

# Allow users to configure custom task file path
# Users can set TASKMAN_DATA_FILE in their .zshrc to customize storage location
# Example: export TASKMAN_DATA_FILE="$HOME/my-tasks/tasks.json"
if [[ -z "$TASKMAN_DATA_FILE" ]]; then
    TASKMAN_DATA_FILE="$TASKMAN_DATA_DIR/tasks.json"
fi

# Ensure data directory exists (for default path)
if [[ "$TASKMAN_DATA_FILE" == "$TASKMAN_DATA_DIR/tasks.json" ]]; then
    [[ ! -d "$TASKMAN_DATA_DIR" ]] && mkdir -p "$TASKMAN_DATA_DIR"
else
    # For custom paths, ensure the directory exists
    custom_dir=$(dirname "$TASKMAN_DATA_FILE")
    [[ ! -d "$custom_dir" ]] && mkdir -p "$custom_dir"
fi

# Color definitions for output
TASKMAN_COLOR_RED="\033[31m"
TASKMAN_COLOR_GREEN="\033[32m"
TASKMAN_COLOR_YELLOW="\033[33m"
TASKMAN_COLOR_BLUE="\033[34m"
TASKMAN_COLOR_CYAN="\033[36m"
TASKMAN_COLOR_RESET="\033[0m"

# Main task manager function
tasks() {
    local action="$1"

    # Only shift if there are arguments
    if [[ $# -gt 0 ]]; then
        shift
    fi

    case "$action" in
        "" | "ui" | "show")
            # Launch the full UI
            _taskman_launch_ui
            ;;
        "add" | "new" | "create")
            # Quick add task from command line
            _taskman_add_task "$@"
            ;;
        "list" | "ls")
            # List tasks in terminal
            _taskman_list_tasks "$@"
            ;;
        "done" | "complete")
            # Mark task as complete
            _taskman_complete_task "$@"
            ;;
        "delete" | "del" | "rm")
            # Delete a task
            _taskman_delete_task "$@"
            ;;
        "sort")
            # Set sorting mode
            _taskman_set_sort "$@"
            ;;
        "help" | "-h" | "--help")
            _taskman_show_help
            ;;
        *)
            echo "${TASKMAN_COLOR_RED}Unknown action: $action${TASKMAN_COLOR_RESET}"
            _taskman_show_help
            return 1
            ;;
    esac
}

# Launch the full UI
_taskman_launch_ui() {
    if ! command -v python3 >/dev/null 2>&1; then
        echo "${TASKMAN_COLOR_RED}Error: Python 3 is required but not installed.${TASKMAN_COLOR_RESET}"
        echo "${TASKMAN_COLOR_YELLOW}Please install Python 3 to use the interactive UI.${TASKMAN_COLOR_RESET}"
        return 1
    fi

    # Set the data file path (use configured path)
    export TASKMAN_DATA_FILE

    # Run the Python task manager
    python3 "$TASKMAN_PLUGIN_DIR/task_manager.py"
}

# Quick add task from command line
_taskman_add_task() {
    if [[ $# -eq 0 ]]; then
        echo "${TASKMAN_COLOR_RED}Error: Please provide task description${TASKMAN_COLOR_RESET}"
        echo "Usage: tasks add <task description> [priority]"
        return 1
    fi

    local task_text="$1"
    local priority="${2:-normal}"

    # Validate priority
    case "$priority" in
        "high"|"normal"|"low")
            ;;
        *)
            echo "${TASKMAN_COLOR_YELLOW}Warning: Invalid priority '$priority', using 'normal'${TASKMAN_COLOR_RESET}"
            priority="normal"
            ;;
    esac

    if command -v python3 >/dev/null 2>&1; then
        TASKMAN_DATA_FILE="$TASKMAN_DATA_FILE" python3 "$TASKMAN_PLUGIN_DIR/task_cli.py" add "$task_text" "$priority"

        # Show color-coded confirmation
        local priority_color
        case "$priority" in
            "high") priority_color="$TASKMAN_COLOR_RED" ;;
            "low") priority_color="$TASKMAN_COLOR_CYAN" ;;
            *) priority_color="$TASKMAN_COLOR_YELLOW" ;;
        esac

        echo "${TASKMAN_COLOR_GREEN}✓ Added task:${TASKMAN_COLOR_RESET} ${priority_color}[$priority]${TASKMAN_COLOR_RESET} $task_text"
    else
        echo "${TASKMAN_COLOR_RED}Error: Python 3 is required for task management.${TASKMAN_COLOR_RESET}"
        return 1
    fi
}

# List tasks in terminal
_taskman_list_tasks() {
    local filter="$1"

    if command -v python3 >/dev/null 2>&1; then
        TASKMAN_DATA_FILE="$TASKMAN_DATA_FILE" python3 "$TASKMAN_PLUGIN_DIR/task_cli.py" list "$filter"
    else
        echo "${TASKMAN_COLOR_RED}Error: Python 3 is required for task management.${TASKMAN_COLOR_RESET}"
        return 1
    fi
}

# Complete a task
_taskman_complete_task() {
    if [[ $# -eq 0 ]]; then
        echo "${TASKMAN_COLOR_RED}Error: Please provide task ID${TASKMAN_COLOR_RESET}"
        echo "Usage: tasks done <task_id>"
        return 1
    fi

    local task_id="$1"
    if command -v python3 >/dev/null 2>&1; then
        TASKMAN_DATA_FILE="$TASKMAN_DATA_FILE" python3 "$TASKMAN_PLUGIN_DIR/task_cli.py" complete "$task_id"
    else
        echo "${TASKMAN_COLOR_RED}Error: Python 3 is required for task management.${TASKMAN_COLOR_RESET}"
        return 1
    fi
}

# Delete a task
_taskman_delete_task() {
    if [[ $# -eq 0 ]]; then
        echo "${TASKMAN_COLOR_RED}Error: Please provide task ID${TASKMAN_COLOR_RESET}"
        echo "Usage: tasks delete <task_id>"
        return 1
    fi

    local task_id="$1"
    if command -v python3 >/dev/null 2>&1; then
        TASKMAN_DATA_FILE="$TASKMAN_DATA_FILE" python3 "$TASKMAN_PLUGIN_DIR/task_cli.py" delete "$task_id"
    else
        echo "${TASKMAN_COLOR_RED}Error: Python 3 is required for task management.${TASKMAN_COLOR_RESET}"
        return 1
    fi
}

# Set sorting mode
_taskman_set_sort() {
    if [[ $# -eq 0 ]]; then
        echo "${TASKMAN_COLOR_RED}Error: Please provide sort mode${TASKMAN_COLOR_RESET}"
        echo "Usage: tasks sort <mode>"
        echo "Available modes: default, priority, alphabetical"
        return 1
    fi

    local sort_mode="$1"
    if command -v python3 >/dev/null 2>&1; then
        TASKMAN_DATA_FILE="$TASKMAN_DATA_FILE" python3 "$TASKMAN_PLUGIN_DIR/task_cli.py" sort "$sort_mode"
    else
        echo "${TASKMAN_COLOR_RED}Error: Python 3 is required for task management.${TASKMAN_COLOR_RESET}"
        return 1
    fi
}

# Show help
_taskman_show_help() {
    cat << 'EOF'
Terminal Task Manager - Oh-My-Zsh Plugin v2.0

Usage:
  tasks [action] [arguments]

Actions:
  (no action)    Launch full interactive UI
  ui, show       Launch full interactive UI
  add <text> [priority]  Add new task (priority: high, normal, low)
  list [filter]  List tasks (filter: all, pending, completed)
  done <id>      Mark task as completed
  delete <id>    Delete a task
  sort <mode>    Set sorting mode (default, priority, alphabetical)
  help           Show this help

Examples:
  tasks                          # Launch interactive UI
  tasks add "Fix bug in login"   # Add normal priority task
  tasks add "Deploy to prod" high  # Add high priority task
  tasks list                     # List all tasks
  tasks list pending             # List only pending tasks
  tasks done 3                   # Mark task ID 3 as completed
  tasks delete 5                 # Delete task ID 5
  tasks sort priority            # Sort by priority

Interactive UI Keys:
  ↑/k    Move up        n      New task
  ↓/j    Move down      Space  Toggle completion
  s      Cycle sort     d      Delete task
  p      Sort priority  a      Sort alphabetical
  h      Help           q      Quit

Features:
  • Configurable storage location via TASKMAN_DATA_FILE environment variable
  • Automatic sorting with completed tasks always at bottom
  • Priority-based text colors with dimmed completed tasks
  • Humanized creation timers showing task age
  • Visual separator between active and completed tasks
  • Multiple sort modes: creation order, priority, alphabetical

Priority Colors:
  • High Priority (!) - Red text for active, dimmed red for completed
  • Normal Priority (-) - Yellow text for active, dimmed yellow for completed
  • Low Priority (·) - Cyan text for active, dimmed cyan for completed

Data Storage:
  Default: ~/.taskman/tasks.json
  Custom:  Set TASKMAN_DATA_FILE environment variable

Configuration:
  # In your ~/.zshrc (before loading Oh-My-Zsh)
  export TASKMAN_DATA_FILE="$HOME/Documents/my-tasks.json"

Priority Levels:
  • High Priority (!) - Red text, for urgent tasks
  • Normal Priority (-) - Yellow text, default priority
  • Low Priority (·) - Cyan text, for less urgent tasks

Color Scheme:
  • Task text is colored based on priority and completion status
  • Completed tasks show dimmed priority colors to maintain context
  • Visual separator divides active and completed tasks
EOF
}

# Aliases for convenience
alias taskman='tasks'
alias tm='tasks'
alias task='tasks'
alias todo='tasks'

# Auto-completion for task actions
_taskman_completion() {
    local -a actions
    actions=(
        'ui:Launch interactive UI'
        'show:Launch interactive UI'
        'add:Add new task'
        'new:Add new task'
        'create:Add new task'
        'list:List tasks'
        'ls:List tasks'
        'done:Mark task complete'
        'complete:Mark task complete'
        'delete:Delete task'
        'del:Delete task'
        'rm:Delete task'
        'sort:Set sorting mode'
        'help:Show help'
    )
    _describe 'actions' actions
}

compdef _taskman_completion tasks tm task todo

# Quick access function for sidebar workflow
task-sidebar() {
    echo "${TASKMAN_COLOR_BLUE}Starting task manager in sidebar mode...${TASKMAN_COLOR_RESET}"
    echo "${TASKMAN_COLOR_YELLOW}Tip: Use 'Cmd+D' (or equivalent) to split terminal horizontally${TASKMAN_COLOR_RESET}"
    echo "${TASKMAN_COLOR_CYAN}New features: Sort with 's/p/a' keys, completed tasks auto-move to bottom${TASKMAN_COLOR_RESET}"
    tasks ui
}

# Show a quick summary on shell startup (optional)
# Uncomment the next line if you want to see task summary when opening terminal
# _taskman_startup_summary

_taskman_startup_summary() {
    if [[ -f "$TASKMAN_DATA_FILE" ]] && command -v python3 >/dev/null 2>&1; then
        local pending_count=$(TASKMAN_DATA_FILE="$TASKMAN_DATA_FILE" python3 "$TASKMAN_PLUGIN_DIR/task_cli.py" count pending 2>/dev/null || echo "0")
        local completed_count=$(TASKMAN_DATA_FILE="$TASKMAN_DATA_FILE" python3 "$TASKMAN_PLUGIN_DIR/task_cli.py" count completed 2>/dev/null || echo "0")

        if [[ "$pending_count" -gt 0 ]]; then
            echo "${TASKMAN_COLOR_CYAN}📋 Task Summary: ${pending_count} pending, ${completed_count} completed${TASKMAN_COLOR_RESET}"
            echo "${TASKMAN_COLOR_YELLOW}   Type 'tasks' to manage your tasks${TASKMAN_COLOR_RESET}"
        fi
    fi
}

