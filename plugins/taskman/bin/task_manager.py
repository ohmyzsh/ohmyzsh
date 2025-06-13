#!/usr/bin/env python3
"""
Terminal Task Manager - A sidebar-style task manager for the terminal

Features:
- Sidebar display in terminal
- Keyboard shortcuts for task operations
- Persistent task storage
- Task prioritization and highlighting
"""

import curses
import json
import os
from datetime import datetime
from typing import List, Dict, Optional

class Task:
    def __init__(self, id: int, text: str, completed: bool = False, priority: str = "normal", created_at: str = None):
        self.id = id
        self.text = text
        self.completed = completed
        self.priority = priority  # "high", "normal", "low"
        self.created_at = created_at or datetime.now().isoformat()
    
    def to_dict(self) -> Dict:
        return {
            "id": self.id,
            "text": self.text,
            "completed": self.completed,
            "priority": self.priority,
            "created_at": self.created_at
        }
    
    @classmethod
    def from_dict(cls, data: Dict) -> 'Task':
        return cls(
            id=data["id"],
            text=data["text"],
            completed=data["completed"],
            priority=data.get("priority", "normal"),
            created_at=data.get("created_at")
        )

class TaskManager:
    def __init__(self, data_file: str = None):
        # Use environment variable or default path
        self.data_file = data_file or os.environ.get('TASKMAN_DATA_FILE', os.path.expanduser("~/.taskman/tasks.json"))
        self.tasks: List[Task] = []
        self.selected_index = 0
        self.next_id = 1
        self.load_tasks()
    
    def load_tasks(self):
        """Load tasks from JSON file"""
        if os.path.exists(self.data_file):
            try:
                with open(self.data_file, 'r') as f:
                    data = json.load(f)
                    self.tasks = [Task.from_dict(task_data) for task_data in data.get("tasks", [])]
                    self.next_id = data.get("next_id", 1)
            except (json.JSONDecodeError, FileNotFoundError):
                self.tasks = []
                self.next_id = 1
    
    def save_tasks(self):
        """Save tasks to JSON file"""
        # Ensure directory exists
        os.makedirs(os.path.dirname(self.data_file), exist_ok=True)
        
        data = {
            "tasks": [task.to_dict() for task in self.tasks],
            "next_id": self.next_id
        }
        with open(self.data_file, 'w') as f:
            json.dump(data, f, indent=2)
    
    def add_task(self, text: str, priority: str = "normal") -> Task:
        """Add a new task"""
        task = Task(self.next_id, text, priority=priority)
        self.tasks.append(task)
        self.next_id += 1
        self.save_tasks()
        return task
    
    def toggle_task(self, task_id: int):
        """Toggle task completion status"""
        for task in self.tasks:
            if task.id == task_id:
                task.completed = not task.completed
                self.save_tasks()
                break
    
    def delete_task(self, task_id: int):
        """Delete a task"""
        self.tasks = [task for task in self.tasks if task.id != task_id]
        self.save_tasks()
        if self.selected_index >= len(self.tasks) and self.tasks:
            self.selected_index = len(self.tasks) - 1
        elif not self.tasks:
            self.selected_index = 0
    
    def get_selected_task(self) -> Optional[Task]:
        """Get currently selected task"""
        if 0 <= self.selected_index < len(self.tasks):
            return self.tasks[self.selected_index]
        return None
    
    def move_selection(self, direction: int):
        """Move selection up or down"""
        if self.tasks:
            self.selected_index = max(0, min(len(self.tasks) - 1, self.selected_index + direction))

class TaskManagerUI:
    def __init__(self):
        self.task_manager = TaskManager()
        self.input_mode = False
        self.input_text = ""
        self.input_priority = "normal"
        self.show_help = False
    
    def run(self, stdscr):
        """Main application loop"""
        curses.curs_set(0)  # Hide cursor
        stdscr.nodelay(1)   # Non-blocking input
        stdscr.timeout(100) # Refresh every 100ms
        
        # Color pairs
        curses.start_color()
        curses.init_pair(1, curses.COLOR_WHITE, curses.COLOR_BLUE)    # Selected
        curses.init_pair(2, curses.COLOR_GREEN, curses.COLOR_BLACK)   # Completed
        curses.init_pair(3, curses.COLOR_RED, curses.COLOR_BLACK)     # High priority
        curses.init_pair(4, curses.COLOR_YELLOW, curses.COLOR_BLACK)  # Normal priority
        curses.init_pair(5, curses.COLOR_CYAN, curses.COLOR_BLACK)    # Low priority
        curses.init_pair(6, curses.COLOR_WHITE, curses.COLOR_BLACK)   # Default
        curses.init_pair(7, curses.COLOR_BLACK, curses.COLOR_WHITE)   # Input mode
        
        while True:
            self.draw_ui(stdscr)
            
            try:
                key = stdscr.getch()
            except:
                continue
            
            if key == -1:
                continue
            
            if self.input_mode:
                if self.handle_input_mode(key):
                    break
            else:
                if self.handle_normal_mode(key):
                    break
    
    def draw_ui(self, stdscr):
        """Draw the user interface"""
        stdscr.clear()
        height, width = stdscr.getmaxyx()
        
        # Title
        title = "Terminal Task Manager (osh plugin)"
        stdscr.addstr(0, 2, title, curses.A_BOLD)
        stdscr.addstr(0, width - 20, f"Tasks: {len(self.task_manager.tasks)}", curses.A_DIM)
        
        # Help line
        if not self.show_help:
            help_text = "Press 'h' for help, 'q' to quit"
            stdscr.addstr(1, 2, help_text, curses.A_DIM)
        
        # Tasks list
        start_row = 3
        for i, task in enumerate(self.task_manager.tasks):
            if start_row + i >= height - 3:
                break
            
            # Determine color based on task status and priority
            color = curses.color_pair(6)  # Default
            if task.completed:
                color = curses.color_pair(2)  # Green for completed
            elif task.priority == "high":
                color = curses.color_pair(3)  # Red for high priority
            elif task.priority == "low":
                color = curses.color_pair(5)  # Cyan for low priority
            else:
                color = curses.color_pair(4)  # Yellow for normal priority
            
            # Highlight selected task
            if i == self.task_manager.selected_index:
                color |= curses.A_REVERSE
            
            # Task status icon
            status_icon = "✓" if task.completed else "○"
            priority_icon = {
                "high": "!",
                "normal": "-",
                "low": "·"
            }.get(task.priority, "-")
            
            # Truncate task text if too long
            max_text_width = width - 15
            task_text = task.text[:max_text_width] + "..." if len(task.text) > max_text_width else task.text
            
            task_line = f" {status_icon} [{priority_icon}] {task_text}"
            stdscr.addstr(start_row + i, 2, task_line, color)
        
        # Input area
        if self.input_mode:
            input_y = height - 3
            stdscr.addstr(input_y, 2, "New task: ", curses.A_BOLD)
            stdscr.addstr(input_y, 12, self.input_text, curses.color_pair(7))
            stdscr.addstr(input_y + 1, 2, f"Priority: {self.input_priority} (Tab to change)", curses.A_DIM)
            curses.curs_set(1)  # Show cursor in input mode
        else:
            curses.curs_set(0)  # Hide cursor
        
        # Help panel
        if self.show_help:
            self.draw_help(stdscr, height, width)
        
        # Status line
        status_y = height - 1
        if self.input_mode:
            status_text = "Enter: Save task | Esc: Cancel | Tab: Change priority"
        else:
            status_text = "n: New | Space: Toggle | d: Delete | ↑↓: Navigate | h: Help | q: Quit"
        
        stdscr.addstr(status_y, 2, status_text[:width-4], curses.A_DIM)
        
        stdscr.refresh()
    
    def draw_help(self, stdscr, height, width):
        """Draw help panel"""
        help_lines = [
            "KEYBOARD SHORTCUTS:",
            "",
            "Navigation:",
            "  ↑/k    - Move up",
            "  ↓/j    - Move down",
            "",
            "Task Operations:",
            "  n      - New task",
            "  Space  - Toggle completion",
            "  d      - Delete task",
            "",
            "Priority Levels:",
            "  !  High priority (red)",
            "  -  Normal priority (yellow)",
            "  ·  Low priority (cyan)",
            "",
            "Other:",
            "  h      - Toggle this help",
            "  q      - Quit application",
            "",
            "CLI Usage:",
            "  tasks add 'text' [priority]",
            "  tasks list [filter]",
            "  tasks done <id>",
            "  tasks delete <id>",
        ]
        
        # Calculate help panel size
        help_width = max(len(line) for line in help_lines) + 4
        help_height = len(help_lines) + 2
        
        start_x = max(2, (width - help_width) // 2)
        start_y = max(2, (height - help_height) // 2)
        
        # Draw help background
        for i in range(help_height):
            stdscr.addstr(start_y + i, start_x, " " * help_width, curses.color_pair(7))
        
        # Draw help content
        for i, line in enumerate(help_lines):
            stdscr.addstr(start_y + 1 + i, start_x + 2, line, curses.color_pair(7))
    
    def handle_normal_mode(self, key) -> bool:
        """Handle key presses in normal mode"""
        # Quit
        if key == ord('q'):
            return True
        
        # Navigation
        elif key == curses.KEY_UP or key == ord('k'):
            self.task_manager.move_selection(-1)
        elif key == curses.KEY_DOWN or key == ord('j'):
            self.task_manager.move_selection(1)
        
        # Task operations
        elif key == ord('n'):
            self.input_mode = True
            self.input_text = ""
            self.input_priority = "normal"
        elif key == ord(' '):
            selected_task = self.task_manager.get_selected_task()
            if selected_task:
                self.task_manager.toggle_task(selected_task.id)
        elif key == ord('d'):
            selected_task = self.task_manager.get_selected_task()
            if selected_task:
                self.task_manager.delete_task(selected_task.id)
        
        # Help
        elif key == ord('h'):
            self.show_help = not self.show_help
        
        return False
    
    def handle_input_mode(self, key) -> bool:
        """Handle key presses in input mode"""
        if key == 27:  # Escape
            self.input_mode = False
            self.input_text = ""
        elif key == ord('\n') or key == 10:  # Enter
            if self.input_text.strip():
                self.task_manager.add_task(self.input_text.strip(), self.input_priority)
            self.input_mode = False
            self.input_text = ""
        elif key == ord('\t'):  # Tab - cycle priority
            priorities = ["normal", "high", "low"]
            current_index = priorities.index(self.input_priority)
            self.input_priority = priorities[(current_index + 1) % len(priorities)]
        elif key == curses.KEY_BACKSPACE or key == 127:
            self.input_text = self.input_text[:-1]
        elif 32 <= key <= 126:  # Printable characters
            self.input_text += chr(key)
        
        return False

def main():
    """Main entry point"""
    ui = TaskManagerUI()
    try:
        curses.wrapper(ui.run)
    except KeyboardInterrupt:
        print("\nGoodbye!")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()

