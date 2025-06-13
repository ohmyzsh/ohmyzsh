#!/usr/bin/env zsh
#
# Terminal Task Manager Plugin for Oh-My-Zsh
# A powerful sidebar-style task manager that runs entirely in your terminal
#
# Author: @oiahoon
# Version: 1.0.0
# Repository: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/taskman
#
# Features:
# - Interactive terminal UI with keyboard shortcuts
# - Command line interface for quick operations
# - Priority system with color coding
# - Persistent JSON storage
# - Vim-like keybindings
# - Zero external dependencies (Python 3 only)
#

# Plugin directory detection (Oh-My-Zsh compatible)
TASKMAN_PLUGIN_DIR="${0:h}"

# Data directory (store tasks in home directory)
TASKMAN_DATA_DIR="$HOME/.taskman"

# Ensure data directory exists
[[ ! -d "$TASKMAN_DATA_DIR" ]] && mkdir -p "$TASKMAN_DATA_DIR"

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
    shift
    
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
    
    # Set the data file path
    export TASKMAN_DATA_FILE="$TASKMAN_DATA_DIR/tasks.json"
    
    # Run the Python task manager
    python3 "$TASKMAN_PLUGIN_DIR/bin/task_manager.py"
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
        python3 "$TASKMAN_PLUGIN_DIR/bin/task_cli.py" add "$task_text" "$priority"
        
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
        python3 "$TASKMAN_PLUGIN_DIR/bin/task_cli.py" list "$filter"
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
        python3 "$TASKMAN_PLUGIN_DIR/bin/task_cli.py" complete "$task_id"
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
        python3 "$TASKMAN_PLUGIN_DIR/bin/task_cli.py" delete "$task_id"
    else
        echo "${TASKMAN_COLOR_RED}Error: Python 3 is required for task management.${TASKMAN_COLOR_RESET}"
        return 1
    fi
}

# Show help
_taskman_show_help() {
    cat << 'EOF'
Terminal Task Manager - Oh-My-Zsh Plugin

Usage:
  tasks [action] [arguments]

Actions:
  (no action)    Launch full interactive UI
  ui, show       Launch full interactive UI
  add <text> [priority]  Add new task (priority: high, normal, low)
  list [filter]  List tasks (filter: all, pending, completed)
  done <id>      Mark task as completed
  delete <id>    Delete a task
  help           Show this help

Examples:
  tasks                          # Launch interactive UI
  tasks add "Fix bug in login"   # Add normal priority task
  tasks add "Deploy to prod" high  # Add high priority task
  tasks list                     # List all tasks
  tasks list pending             # List only pending tasks
  tasks done 3                   # Mark task ID 3 as completed
  tasks delete 5                 # Delete task ID 5

Interactive UI Keys:
  ↑/k    Move up        n      New task
  ↓/j    Move down      Space  Toggle completion
  h      Help           d      Delete task
  q      Quit

Aliases:
  tm, task, todo - All point to 'tasks' command

Data Storage:
  Tasks are stored in: ~/.taskman/tasks.json

Requirements:
  Python 3.6+ (for interactive UI and CLI operations)
EOF
}

# Convenient aliases
alias tm='tasks'
alias task='tasks'
alias todo='tasks'

# Quick access function for sidebar workflow
task-sidebar() {
    echo "${TASKMAN_COLOR_BLUE}Starting task manager in sidebar mode...${TASKMAN_COLOR_RESET}"
    echo "${TASKMAN_COLOR_YELLOW}Tip: Use terminal split to run this alongside your work${TASKMAN_COLOR_RESET}"
    tasks ui
}

# Optional: Show task summary on shell startup
# Uncomment the next line to enable startup summary
# _taskman_startup_summary

_taskman_startup_summary() {
    if [[ -f "$TASKMAN_DATA_DIR/tasks.json" ]] && command -v python3 >/dev/null 2>&1; then
        local pending_count=$(python3 "$TASKMAN_PLUGIN_DIR/bin/task_cli.py" count pending 2>/dev/null || echo "0")
        local completed_count=$(python3 "$TASKMAN_PLUGIN_DIR/bin/task_cli.py" count completed 2>/dev/null || echo "0")
        
        if [[ "$pending_count" -gt 0 ]]; then
            echo "${TASKMAN_COLOR_CYAN}📋 Task Summary: ${pending_count} pending, ${completed_count} completed${TASKMAN_COLOR_RESET}"
            echo "${TASKMAN_COLOR_YELLOW}   Type 'tasks' to manage your tasks${TASKMAN_COLOR_RESET}"
        fi
    fi
}

