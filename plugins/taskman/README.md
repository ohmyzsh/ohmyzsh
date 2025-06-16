# Taskman v2.0 - Oh My Zsh Plugin

A modern, feature-rich terminal task manager plugin for Oh My Zsh. Taskman provides an intuitive sidebar-style interface for managing your tasks with advanced features like priority-based coloring, humanized timers, and even a fun running cat animation!

## ✨ Features

### Core Functionality
- **Sidebar Interface**: Clean, terminal-based UI that doesn't interfere with your workflow
- **Persistent Storage**: Tasks are automatically saved to JSON format
- **Priority System**: Three priority levels (high, normal, low) with visual indicators
- **Task Operations**: Add, complete, delete, and navigate tasks with keyboard shortcuts

### Advanced Features
- **Smart Sorting**: Multiple sort modes (creation order, priority, alphabetical) with completed tasks always at bottom
- **Priority-Based Colors**: Task text colored by priority (red=high, yellow=normal, cyan=low)
- **Humanized Timers**: Shows task age in human-readable format ([5m], [2h], [3d]) using local timezone
- **Visual Separation**: Horizontal line separates active and completed tasks
- **Configurable Storage**: Set custom task file location via `TASKMAN_DATA_FILE` environment variable
- **Completed Task Dimming**: Completed tasks retain priority colors but are visually dimmed
- **Fun Animation**: Optional Chrome dino-style mini-game for entertainment (toggle with 'x')

### Display Format
```
Taskman v2.0                                    [Sort: default]
Pending: 3, Completed: 1                Press 'h' for help, 'q' to quit

[  5m] ○ [!] Fix critical bug in authentication system
[ 2h] ○ [-] Review pull request #123
[now] ○ [·] Update documentation

─────────────────────────────────────────────────────────────────

[ 1d] ✓ [!] Complete project setup

        ◆
. . . ● . . . | . . . ▌ . . . █ . . . ┃ . . . ▐ . . .

n: New | Space: Toggle | d: Delete | s: Sort | ↑↓: Navigate | h: Help | q: Quit
```

## 🚀 Installation

### Manual Installation
   ```bash
# Clone or copy the plugin to your Oh My Zsh plugins directory
cp -r taskman ~/.oh-my-zsh/plugins/

# Add to your .zshrc plugins list
plugins=(... taskman)

# Reload your shell
   source ~/.zshrc
   ```

### Using Oh My Zsh Plugin Manager
If you're using a plugin manager like `oh-my-zsh-plugins`:
   ```bash
# Add to your plugin list
plugins=(... taskman)
   ```

## 🎮 Usage

### Interactive UI
Launch the interactive task manager:
```bash
taskman
# or use aliases
tasks
tm
todo
```

### Keyboard Shortcuts

#### Navigation
- `↑/k` - Move selection up
- `↓/j` - Move selection down

#### Task Operations
- `n` - Create new task
- `Space` - Toggle task completion
- `d` - Delete selected task

#### Sorting
- `s` - Cycle through sort modes (default → priority → alphabetical)
- `p` - Sort by priority (high → normal → low)
- `a` - Sort alphabetically

#### Other
- `h` - Toggle help panel
- `x` - Toggle animation on/off
- `q` - Quit application

### Command Line Interface
```bash
# Add a new task
tasks add "Complete project documentation"
tasks add "Fix bug in login system" high

# List tasks
tasks list
tasks list pending
tasks list completed

# Mark task as completed
tasks done 1

# Delete a task
tasks delete 2

# Sort tasks
tasks sort priority
tasks sort alphabetical
tasks sort default

# Show help
tasks help
```

## ⚙️ Configuration

### Custom Storage Location
Set a custom location for your task file:
```bash
export TASKMAN_DATA_FILE="$HOME/my-tasks.json"
```

### Priority Levels
- **High Priority** (`!`): Red text - urgent tasks
- **Normal Priority** (`-`): Yellow text - regular tasks
- **Low Priority** (`·`): Cyan text - nice-to-have tasks

## 🎨 Visual Features

### Color System
- **Active Tasks**: Text colored by priority (red/yellow/cyan)
- **Completed Tasks**: Same priority colors but dimmed for subtle indication
- **Status Bullets**: Green checkmarks for completed, colored circles for active
- **Selection**: Reverse highlighting for currently selected task

### Timer Display
- Shows how long ago each task was created
- Updates in real-time for active tasks
- Uses local timezone for accurate time calculation
- Formats: `[now]`, `[5m]`, `[2h]`, `[3d]`

### Mini-Game Animation
- Chrome dino-style side-scrolling game with jumping player and obstacles
- Press 'x' to toggle animation on/off
- Automatic jumping and varied obstacles for entertainment
- Runs alongside task management without interference

## 📁 File Structure
```
~/.taskman/
└── tasks.json          # Task storage (default location)
```

### Task Data Format
```json
{
  "tasks": [
    {
      "id": 1,
      "text": "Complete project setup",
      "completed": true,
      "priority": "high",
      "created_at": "2024-01-15T10:30:00"
    }
  ],
  "next_id": 2,
  "sort_mode": "default"
}
```

## 🔧 Technical Details

- **Language**: Python 3.6+
- **Dependencies**: Built-in libraries only (curses, json, datetime)
- **Storage**: JSON format for human-readable task data
- **Cross-platform**: Works on macOS, Linux, and other Unix-like systems
- **Performance**: Efficient curses-based rendering with 100ms refresh rate

## 🎯 Tips & Tricks

1. **Quick Task Entry**: Use Tab in input mode to cycle through priority levels
2. **Efficient Navigation**: Use `k`/`j` (vim-style) or arrow keys for navigation
3. **Sort Persistence**: Your preferred sort mode is remembered between sessions
4. **Bulk Operations**: Use CLI commands for scripting and automation
5. **Custom Storage**: Set `TASKMAN_DATA_FILE` to sync tasks across different setups
6. **Visual Cues**: Completed tasks are automatically moved to bottom with visual separator
7. **Time Awareness**: Timer shows local time, perfect for tracking task age across time zones

## 🐛 Troubleshooting

### Common Issues
- **Unicode Display**: Ensure your terminal supports Unicode for proper emoji display
- **Color Issues**: Some terminals may not support all color combinations
- **Permission Errors**: Check write permissions for the task storage directory

### Debug Mode
```bash
# Run with Python directly for debugging
python3 ~/.oh-my-zsh/plugins/taskman/task_manager.py
```

## 🤝 Contributing

This is an Oh My Zsh version of the Taskman plugin. For contributions and bug reports, please refer to the original osh framework repository.

## 📄 License

Part of the Oh My Zsh ecosystem. See individual license files for details.

---

**Enjoy managing your tasks with style! 🐱✨**

