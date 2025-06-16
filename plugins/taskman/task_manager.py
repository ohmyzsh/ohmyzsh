#!/usr/bin/env python3
"""
Terminal Task Manager - A sidebar-style task manager for the terminal

Features:
- Sidebar display in terminal
- Keyboard shortcuts for task operations
- Persistent task storage
- Task prioritization and highlighting
- Configurable sorting with completed tasks at bottom
- Color-coded task text with priority-based colors
- Humanized creation timers with local timezone
- Visual separator for completed tasks
- Fun running cat animation
"""

import curses
import json
import os
import random
import time
from datetime import datetime, timezone
from typing import List, Dict, Optional

# Import the separate animation module
from dino_animation import DinoAnimation

def humanize_time_delta(created_at: str) -> str:
    """Convert ISO timestamp to human-readable time delta using local timezone"""
    try:
        created = datetime.fromisoformat(created_at.replace('Z', '+00:00'))
        if created.tzinfo is None:
            # If no timezone info, assume it's local time
            created = created.replace(tzinfo=timezone.utc).astimezone()
        else:
            # Convert to local timezone
            created = created.astimezone()

        now = datetime.now().astimezone()
        delta = now - created

        days = delta.days
        hours = delta.seconds // 3600
        minutes = (delta.seconds % 3600) // 60

        if days > 0:
            return f"{days}d"
        elif hours > 0:
            return f"{hours}h"
        elif minutes > 0:
            return f"{minutes}m"
        else:
            return "now"
    except:
        return "?"

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
        self.sort_mode = "default"  # "default", "priority", "alphabetical"
        self.load_tasks()

    def load_tasks(self):
        """Load tasks from JSON file"""
        if os.path.exists(self.data_file):
            try:
                with open(self.data_file, 'r') as f:
                    data = json.load(f)
                    self.tasks = [Task.from_dict(task_data) for task_data in data.get("tasks", [])]
                    self.next_id = data.get("next_id", 1)
                    self.sort_mode = data.get("sort_mode", "default")
            except (json.JSONDecodeError, FileNotFoundError):
                self.tasks = []
                self.next_id = 1
                self.sort_mode = "default"

    def save_tasks(self):
        """Save tasks to JSON file"""
        # Ensure directory exists
        os.makedirs(os.path.dirname(self.data_file), exist_ok=True)

        data = {
            "tasks": [task.to_dict() for task in self.tasks],
            "next_id": self.next_id,
            "sort_mode": self.sort_mode
        }
        with open(self.data_file, 'w') as f:
            json.dump(data, f, indent=2)

    def add_task(self, text: str, priority: str = "normal") -> Task:
        """Add a new task"""
        task = Task(self.next_id, text, priority=priority)
        self.tasks.append(task)
        self.next_id += 1
        self.sort_tasks()
        self.save_tasks()
        return task

    def toggle_task(self, task_id: int):
        """Toggle task completion status"""
        for task in self.tasks:
            if task.id == task_id:
                task.completed = not task.completed
                self.sort_tasks()
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

    def set_sort_mode(self, mode: str):
        """Set sorting mode and apply it"""
        if mode in ["default", "priority", "alphabetical"]:
            self.sort_mode = mode
            self.sort_tasks()
            self.save_tasks()

    def cycle_sort_mode(self):
        """Cycle through sort modes"""
        modes = ["default", "priority", "alphabetical"]
        current_index = modes.index(self.sort_mode)
        next_mode = modes[(current_index + 1) % len(modes)]
        self.set_sort_mode(next_mode)

    def sort_tasks(self):
        """Sort tasks with completed tasks always at bottom"""
        if self.sort_mode == "priority":
            # Sort by priority: high -> normal -> low, then by ID
            priority_order = {"high": 0, "normal": 1, "low": 2}
            self.tasks.sort(key=lambda t: (
                t.completed,  # Completed tasks go to bottom
                priority_order.get(t.priority, 1),
                t.id
            ))
        elif self.sort_mode == "alphabetical":
            # Sort alphabetically by task text
            self.tasks.sort(key=lambda t: (
                t.completed,  # Completed tasks go to bottom
                t.text.lower()
            ))
        else:  # default
            # Sort by task ID (creation order)
            self.tasks.sort(key=lambda t: (
                t.completed,  # Completed tasks go to bottom
                t.id
            ))

class TaskManagerUI:
    def __init__(self):
        self.task_manager = TaskManager()
        self.input_mode = False
        self.input_text = ""
        self.input_priority = "normal"
        self.show_help = False
        self.dino_animation = None

    def run(self, stdscr):
        """Main application loop with advanced flicker reduction"""
        curses.curs_set(0)  # Hide cursor
        stdscr.nodelay(1)   # Non-blocking input
        stdscr.timeout(80)  # Slightly slower refresh for stability (80ms)

        # Color pairs
        curses.start_color()
        curses.init_pair(1, curses.COLOR_WHITE, curses.COLOR_BLUE)    # Selected
        curses.init_pair(2, curses.COLOR_GREEN, curses.COLOR_BLACK)   # Completed bullet
        curses.init_pair(3, curses.COLOR_RED, curses.COLOR_BLACK)     # High priority
        curses.init_pair(4, curses.COLOR_YELLOW, curses.COLOR_BLACK)  # Normal priority
        curses.init_pair(5, curses.COLOR_CYAN, curses.COLOR_BLACK)    # Low priority
        curses.init_pair(6, curses.COLOR_WHITE, curses.COLOR_BLACK)   # Default text
        curses.init_pair(7, curses.COLOR_BLACK, curses.COLOR_WHITE)   # Input mode
        curses.init_pair(8, curses.COLOR_BLACK, curses.COLOR_BLACK)   # Dimmed text
        # Completed task colors (grayed out versions)
        curses.init_pair(9, curses.COLOR_RED, curses.COLOR_BLACK)     # Completed high priority (dimmed red)
        curses.init_pair(10, curses.COLOR_YELLOW, curses.COLOR_BLACK) # Completed normal priority (dimmed yellow)
        curses.init_pair(11, curses.COLOR_CYAN, curses.COLOR_BLACK)   # Completed low priority (dimmed cyan)

        # Initialize dino animation
        height, width = stdscr.getmaxyx()
        self.dino_animation = DinoAnimation(width - 4)

        # Enhanced state tracking for flicker reduction
        last_state = {
            'task_count': -1,
            'selected_index': -1,
            'input_mode': False,
            'show_help': False,
            'input_text': '',
            'input_priority': '',
            'sort_mode': '',
            'task_hash': '',  # Hash of all task content
            'animation_enabled': True,
            'last_minute': -1,  # Track minute changes for timer updates
        }

        # Force initial draw
        force_redraw = True
        animation_counter = 0

        while True:
            # Update animation less frequently to reduce flicker
            if self.dino_animation and animation_counter % 2 == 0:  # Update every other cycle
                self.dino_animation.update()
            animation_counter += 1

            # Get current state
            current_state = {
                'task_count': len(self.task_manager.tasks),
                'selected_index': self.task_manager.selected_index,
                'input_mode': self.input_mode,
                'show_help': self.show_help,
                'input_text': self.input_text,
                'input_priority': self.input_priority,
                'sort_mode': self.task_manager.sort_mode,
                'task_hash': self._get_task_hash(),
                'animation_enabled': self.dino_animation.is_enabled() if self.dino_animation else False,
                'last_minute': self._get_current_minute(),
            }

            # Determine what needs to be redrawn
            needs_full_redraw = (
                force_redraw or
                last_state['task_count'] != current_state['task_count'] or
                last_state['task_hash'] != current_state['task_hash'] or
                last_state['input_mode'] != current_state['input_mode'] or
                last_state['show_help'] != current_state['show_help'] or
                last_state['sort_mode'] != current_state['sort_mode'] or
                last_state['last_minute'] != current_state['last_minute']  # Redraw when minute changes
            )

            needs_selection_update = (
                last_state['selected_index'] != current_state['selected_index']
            )

            needs_input_update = (
                current_state['input_mode'] and (
                    last_state['input_text'] != current_state['input_text'] or
                    last_state['input_priority'] != current_state['input_priority']
                )
            )

            needs_animation_update = (
                current_state['animation_enabled'] and
                not current_state['input_mode'] and
                not current_state['show_help'] and
                animation_counter % 3 == 0 and  # Update animation every 3rd cycle
                (self.dino_animation.has_display_changed() if self.dino_animation else False)
            )

            # Perform appropriate redraw
            if needs_full_redraw:
                self.draw_ui(stdscr)
                force_redraw = False
            elif needs_selection_update:
                self.update_selection_display(stdscr)
            elif needs_input_update:
                self.update_input_display(stdscr)
            elif needs_animation_update:
                self.update_animation_display(stdscr)

            # Update state tracking
            last_state = current_state.copy()

            try:
                key = stdscr.getch()
            except:
                continue

            if key == -1:
                continue

            # Handle input
            if self.input_mode:
                if self.handle_input_mode(key):
                    break
            else:
                if self.handle_normal_mode(key):
                    break

    def _get_task_hash(self):
        """Generate a hash of all task content to detect changes"""
        task_data = []
        for task in self.task_manager.tasks:
            task_data.append(f"{task.id}:{task.text}:{task.completed}:{task.priority}")
        return hash(tuple(task_data))

    def _get_current_minute(self):
        """Get current minute for timer update detection"""
        from datetime import datetime
        return datetime.now().minute

    def update_selection_display(self, stdscr):
        """Update only the selection highlighting without full redraw"""
        height, width = stdscr.getmaxyx()
        start_row = 3
        completed_count = len([t for t in self.task_manager.tasks if t.completed])

        # Clear previous selection and draw new one
        for i, task in enumerate(self.task_manager.tasks):
            if start_row + i >= height - 8:  # Leave room for animation
                break

            # Skip separator row
            if task.completed and completed_count > 0 and i > 0 and not self.task_manager.tasks[i-1].completed:
                start_row += 1
                if start_row + i >= height - 8:
                    break

            row = start_row + i

            # Only update this row if it's the current or previous selection
            if i == self.task_manager.selected_index or i == getattr(self, '_last_selected', -1):
                # Redraw this task line
                self._draw_task_line(stdscr, task, i, row, width)

        self._last_selected = self.task_manager.selected_index
        stdscr.refresh()

    def update_input_display(self, stdscr):
        """Update only the input area without full redraw"""
        height, width = stdscr.getmaxyx()
        input_y = height - 5

        # Clear input area
        stdscr.addstr(input_y, 2, " " * (width - 4))
        stdscr.addstr(input_y + 1, 2, " " * (width - 4))

        # Redraw input
        stdscr.addstr(input_y, 2, "New task: ", curses.A_BOLD)
        stdscr.addstr(input_y, 12, self.input_text, curses.color_pair(7))
        stdscr.addstr(input_y + 1, 2, f"Priority: {self.input_priority} (Tab to change)", curses.A_DIM)

        stdscr.refresh()

    def update_animation_display(self, stdscr):
        """Update only the animation area without full redraw"""
        if not self.dino_animation or not self.dino_animation.is_enabled():
            return

        height, width = stdscr.getmaxyx()
        animation_y = height - 8

        try:
            # Clear animation area
            for i in range(7):  # 6 animation lines + 1 status line
                stdscr.addstr(animation_y + i, 2, " " * (width - 4))

            # Redraw animation
            self.draw_dino_animation(stdscr, height, width)
            stdscr.refresh()
        except curses.error:
            pass

    def _draw_task_line(self, stdscr, task, index, row, width):
        """Draw a single task line"""
        # Get humanized time
        time_str = humanize_time_delta(task.created_at)

        # Determine colors based on task status and priority
        if task.completed:
            bullet_color = curses.color_pair(2)  # Green for completed bullet
            if task.priority == "high":
                text_color = curses.color_pair(9) | curses.A_DIM   # Dimmed red
            elif task.priority == "low":
                text_color = curses.color_pair(11) | curses.A_DIM  # Dimmed cyan
            else:
                text_color = curses.color_pair(10) | curses.A_DIM  # Dimmed yellow
        else:
            # Active tasks - bullet and text same color based on priority
            if task.priority == "high":
                bullet_color = curses.color_pair(3)  # Red
                text_color = curses.color_pair(3)    # Red
            elif task.priority == "low":
                bullet_color = curses.color_pair(5)  # Cyan
                text_color = curses.color_pair(5)    # Cyan
            else:
                bullet_color = curses.color_pair(4)  # Yellow
                text_color = curses.color_pair(4)    # Yellow

        # Highlight selected task
        if index == self.task_manager.selected_index:
            bullet_color |= curses.A_REVERSE
            text_color |= curses.A_REVERSE

        # Task status and priority icons
        status_icon = "✓" if task.completed else "○"
        priority_icon = {
            "high": "!",
            "normal": "-",
            "low": "·"
        }.get(task.priority, "-")

        # Truncate task text if too long
        max_text_width = width - 25
        task_text = task.text[:max_text_width] + "..." if len(task.text) > max_text_width else task.text

        # Clear the line first
        stdscr.addstr(row, 2, " " * (width - 4))

        # Draw components
        timer_part = f"[{time_str:>3}]"
        stdscr.addstr(row, 2, timer_part, curses.A_DIM)

        bullet_part = f" {status_icon} [{priority_icon}]"
        stdscr.addstr(row, 8, bullet_part, bullet_color)

        text_part = f" {task_text}"
        stdscr.addstr(row, 8 + len(bullet_part), text_part, text_color)

    def draw_ui(self, stdscr):
        """Draw the user interface"""
        stdscr.clear()
        height, width = stdscr.getmaxyx()

        # Title with version
        title = "Taskman v2.2"
        sort_indicator = f"[Sort: {self.task_manager.sort_mode}]"
        stdscr.addstr(0, 2, title, curses.A_BOLD)
        stdscr.addstr(0, width - len(sort_indicator) - 2, sort_indicator, curses.A_DIM)

        # Task count
        pending_count = len([t for t in self.task_manager.tasks if not t.completed])
        completed_count = len([t for t in self.task_manager.tasks if t.completed])
        count_text = f"Pending: {pending_count}, Completed: {completed_count}"
        stdscr.addstr(1, 2, count_text, curses.A_DIM)

        # Help line
        if not self.show_help:
            help_text = "Press 'h' for help, 'q' to quit"
            stdscr.addstr(1, width - len(help_text) - 2, help_text, curses.A_DIM)

        # Tasks list
        start_row = 3
        completed_separator_drawn = False

        # Calculate available space for tasks (leave room for animation)
        max_task_row = height - 5  # Leave 5 lines for animation and status

        for i, task in enumerate(self.task_manager.tasks):
            if start_row + i >= max_task_row:
                break

            # Draw separator before first completed task
            if not completed_separator_drawn and task.completed and completed_count > 0:
                separator = "─" * (width - 4)
                stdscr.addstr(start_row + i, 2, separator, curses.A_DIM)
                start_row += 1
                completed_separator_drawn = True
                if start_row + i >= max_task_row:
                    break

            # Get humanized time
            time_str = humanize_time_delta(task.created_at)

            # Determine colors based on task status and priority
            if task.completed:
                bullet_color = curses.color_pair(2)  # Green for completed bullet
                if task.priority == "high":
                    text_color = curses.color_pair(9) | curses.A_DIM   # Dimmed red
                elif task.priority == "low":
                    text_color = curses.color_pair(11) | curses.A_DIM  # Dimmed cyan
                else:
                    text_color = curses.color_pair(10) | curses.A_DIM  # Dimmed yellow
            else:
                # Active tasks - bullet and text same color based on priority
                if task.priority == "high":
                    bullet_color = curses.color_pair(3)  # Red
                    text_color = curses.color_pair(3)    # Red
                elif task.priority == "low":
                    bullet_color = curses.color_pair(5)  # Cyan
                    text_color = curses.color_pair(5)    # Cyan
                else:
                    bullet_color = curses.color_pair(4)  # Yellow
                    text_color = curses.color_pair(4)    # Yellow

            # Highlight selected task
            if i == self.task_manager.selected_index:
                bullet_color |= curses.A_REVERSE
                text_color |= curses.A_REVERSE

            # Task status and priority icons
            status_icon = "✓" if task.completed else "○"
            priority_icon = {
                "high": "!",
                "normal": "-",
                "low": "·"
            }.get(task.priority, "-")

            # Truncate task text if too long (account for timer)
            max_text_width = width - 25  # Leave space for timer and bullet
            task_text = task.text[:max_text_width] + "..." if len(task.text) > max_text_width else task.text

            # Draw timer
            timer_part = f"[{time_str:>3}]"
            stdscr.addstr(start_row + i, 2, timer_part, curses.A_DIM)

            # Draw bullet with color
            bullet_part = f" {status_icon} [{priority_icon}]"
            stdscr.addstr(start_row + i, 8, bullet_part, bullet_color)

            # Draw task text with priority-based color
            text_part = f" {task_text}"
            stdscr.addstr(start_row + i, 8 + len(bullet_part), text_part, text_color)

        # Input area
        if self.input_mode:
            input_y = height - 5
            stdscr.addstr(input_y, 2, "New task: ", curses.A_BOLD)
            stdscr.addstr(input_y, 12, self.input_text, curses.color_pair(7))
            stdscr.addstr(input_y + 1, 2, f"Priority: {self.input_priority} (Tab to change)", curses.A_DIM)
            curses.curs_set(1)  # Show cursor in input mode
        else:
            curses.curs_set(0)  # Hide cursor

        # Help panel
        if self.show_help:
            self.draw_help(stdscr, height, width)

        # Dino animation (only if not in help mode)
        if not self.show_help and self.dino_animation:
            self.draw_dino_animation(stdscr, height, width)

        # Status line
        status_y = height - 1
        if self.input_mode:
            status_text = "Enter: Save task | Esc: Cancel | Tab: Change priority"
        else:
            status_text = "n: New | Space: Toggle | d: Delete | s: Sort | ↑↓: Navigate | h: Help | x: Animation | q: Quit"

        stdscr.addstr(status_y, 2, status_text[:width-4], curses.A_DIM)

        stdscr.refresh()

    def draw_dino_animation(self, stdscr, height: int, width: int):
        """Draw the enhanced multi-line dino animation at the bottom"""
        # Don't show animation in input mode or help mode to avoid covering input
        if not self.dino_animation or not self.dino_animation.is_enabled() or self.input_mode or self.show_help:
            return

        # Reserve more space for 6-line animation plus status
        animation_y = height - 8

        try:
            # Get all animation lines
            sky_line, high_line, mid_line, jump_line, ground_line, base_line = self.dino_animation.get_display_lines()

            # Draw all 6 lines of animation with proper spacing
            stdscr.addstr(animation_y, 2, sky_line[:width-4], curses.color_pair(6))
            stdscr.addstr(animation_y + 1, 2, high_line[:width-4], curses.color_pair(6))
            stdscr.addstr(animation_y + 2, 2, mid_line[:width-4], curses.color_pair(6))
            stdscr.addstr(animation_y + 3, 2, jump_line[:width-4], curses.color_pair(6))
            stdscr.addstr(animation_y + 4, 2, ground_line[:width-4], curses.color_pair(6))
            stdscr.addstr(animation_y + 5, 2, base_line[:width-4], curses.color_pair(6))

            # Draw animation status
            if self.dino_animation.is_enabled():
                status = self.dino_animation.get_status()
                stdscr.addstr(animation_y + 6, 2, status[:width-4], curses.A_DIM)

        except curses.error:
            # Ignore curses errors (e.g., writing outside screen bounds)
            pass

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
            "Sorting:",
            "  s      - Cycle sort modes",
            "  p      - Sort by priority",
            "  a      - Sort alphabetically",
            "",
            "Priority Levels:",
            "  !  High priority (red text)",
            "  -  Normal priority (yellow text)",
            "  ·  Low priority (cyan text)",
            "",
            "Features:",
            "  • Timer shows task age (local time)",
            "  • Completed tasks are dimmed",
            "  • Separator divides active/completed",
            "  • Running ASCII dino animation for fun!",
            "",
            "Other:",
            "  h      - Toggle this help",
            "  x      - Toggle animation on/off",
            "  q      - Quit application",
            "",
            "CLI Usage:",
            "  tasks add 'text' [priority]",
            "  tasks list [filter]",
            "  tasks done <id>",
            "  tasks delete <id>",
            "",
            "Note: Completed tasks always appear at bottom",
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

        # Sorting shortcuts
        elif key == ord('s'):
            self.task_manager.cycle_sort_mode()
        elif key == ord('p'):
            self.task_manager.set_sort_mode("priority")
        elif key == ord('a'):
            self.task_manager.set_sort_mode("alphabetical")

        # Help
        elif key == ord('h'):
            self.show_help = not self.show_help

        # Animation toggle
        elif key == ord('x'):
            if self.dino_animation:
                enabled = self.dino_animation.toggle_animation()
                # Brief status message could be added here if needed

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

