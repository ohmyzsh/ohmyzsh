#!/usr/bin/env python3
"""
Terminal Task Manager CLI - Command line interface for task operations
"""

import sys
import os
import json
from datetime import datetime
from typing import List, Dict, Optional

# Import the Task and TaskManager classes from task_manager.py
sys.path.append(os.path.dirname(os.path.abspath(__file__)))
from task_manager import Task, TaskManager

class TaskCLI:
    def __init__(self):
        self.task_manager = TaskManager()
    
    def add_task(self, text: str, priority: str = "normal"):
        """Add a new task via CLI"""
        task = self.task_manager.add_task(text, priority)
        return task
    
    def list_tasks(self, filter_type: str = "all"):
        """List tasks with color coding"""
        tasks = self.task_manager.tasks
        
        if filter_type == "pending":
            tasks = [t for t in tasks if not t.completed]
        elif filter_type == "completed":
            tasks = [t for t in tasks if t.completed]
        
        if not tasks:
            if filter_type == "all":
                print("\033[33mNo tasks found. Add your first task with: tasks add 'task description'\033[0m")
            else:
                print(f"\033[33mNo {filter_type} tasks found.\033[0m")
            return
        
        print(f"\033[1m{filter_type.title()} Tasks:\033[0m")
        print()
        
        for task in tasks:
            # Status icon
            status_icon = "✓" if task.completed else "○"
            
            # Priority icon and color
            priority_icons = {"high": "!", "normal": "-", "low": "·"}
            priority_colors = {"high": "\033[31m", "normal": "\033[33m", "low": "\033[36m"}
            
            priority_icon = priority_icons.get(task.priority, "-")
            priority_color = priority_colors.get(task.priority, "\033[33m")
            
            # Task color
            if task.completed:
                task_color = "\033[32m"  # Green for completed
            else:
                task_color = priority_color
            
            # Format task line
            task_line = f"{task_color} {status_icon} [{priority_icon}] (ID: {task.id}) {task.text}\033[0m"
            print(task_line)
        
        print()
        print(f"\033[2mTotal: {len(tasks)} tasks\033[0m")
    
    def complete_task(self, task_id: str):
        """Mark a task as completed"""
        try:
            task_id_int = int(task_id)
        except ValueError:
            print(f"\033[31mError: Invalid task ID '{task_id}'. Must be a number.\033[0m")
            return False
        
        task = next((t for t in self.task_manager.tasks if t.id == task_id_int), None)
        if not task:
            print(f"\033[31mError: Task with ID {task_id_int} not found.\033[0m")
            return False
        
        if task.completed:
            print(f"\033[33mTask '{task.text}' is already completed.\033[0m")
            return True
        
        self.task_manager.toggle_task(task_id_int)
        print(f"\033[32m✓ Completed task: {task.text}\033[0m")
        return True
    
    def delete_task(self, task_id: str):
        """Delete a task"""
        try:
            task_id_int = int(task_id)
        except ValueError:
            print(f"\033[31mError: Invalid task ID '{task_id}'. Must be a number.\033[0m")
            return False
        
        task = next((t for t in self.task_manager.tasks if t.id == task_id_int), None)
        if not task:
            print(f"\033[31mError: Task with ID {task_id_int} not found.\033[0m")
            return False
        
        task_text = task.text
        self.task_manager.delete_task(task_id_int)
        print(f"\033[31m× Deleted task: {task_text}\033[0m")
        return True
    
    def count_tasks(self, filter_type: str = "all"):
        """Count tasks by type"""
        tasks = self.task_manager.tasks
        
        if filter_type == "pending":
            count = len([t for t in tasks if not t.completed])
        elif filter_type == "completed":
            count = len([t for t in tasks if t.completed])
        else:
            count = len(tasks)
        
        print(count)
        return count

def main():
    """Main CLI entry point"""
    if len(sys.argv) < 2:
        print("Usage: task_cli.py <command> [args...]")
        sys.exit(1)
    
    cli = TaskCLI()
    command = sys.argv[1].lower()
    
    try:
        if command == "add":
            if len(sys.argv) < 3:
                print("\033[31mError: Please provide task description\033[0m")
                sys.exit(1)
            
            text = sys.argv[2]
            priority = sys.argv[3] if len(sys.argv) > 3 else "normal"
            
            # Validate priority
            if priority not in ["high", "normal", "low"]:
                print(f"\033[33mWarning: Invalid priority '{priority}', using 'normal'\033[0m")
                priority = "normal"
            
            cli.add_task(text, priority)
        
        elif command == "list":
            filter_type = sys.argv[2] if len(sys.argv) > 2 else "all"
            if filter_type not in ["all", "pending", "completed"]:
                print(f"\033[33mWarning: Invalid filter '{filter_type}', using 'all'\033[0m")
                filter_type = "all"
            cli.list_tasks(filter_type)
        
        elif command == "complete":
            if len(sys.argv) < 3:
                print("\033[31mError: Please provide task ID\033[0m")
                sys.exit(1)
            cli.complete_task(sys.argv[2])
        
        elif command == "delete":
            if len(sys.argv) < 3:
                print("\033[31mError: Please provide task ID\033[0m")
                sys.exit(1)
            cli.delete_task(sys.argv[2])
        
        elif command == "count":
            filter_type = sys.argv[2] if len(sys.argv) > 2 else "all"
            cli.count_tasks(filter_type)
        
        else:
            print(f"\033[31mError: Unknown command '{command}'\033[0m")
            print("Available commands: add, list, complete, delete, count")
            sys.exit(1)
    
    except Exception as e:
        print(f"\033[31mError: {e}\033[0m")
        sys.exit(1)

if __name__ == "__main__":
    main()

