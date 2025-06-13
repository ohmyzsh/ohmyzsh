# taskman

A powerful terminal task manager plugin for Oh-My-Zsh. Manage your daily tasks without leaving the command line!

![Task Manager Demo](https://via.placeholder.com/600x400/1e1e1e/00ff00?text=Terminal+Task+Manager+Demo)

## Features

- 📝 **Dual Interface**: Both interactive TUI and CLI operations
- ⌨️ **Vim-like Keybindings**: Navigate with `j`/`k`, `Space` to toggle
- 🎯 **Priority System**: High, normal, and low priority with color coding
- 💾 **Persistent Storage**: Tasks saved in `~/.taskman/tasks.json`
- 🎨 **Rich Colors**: Visual indicators for task status and priority
- ⚡ **Zero Config**: Works immediately after installation
- 🔧 **Shell Integration**: Aliases, completion, and sidebar workflow

## Installation

1. Add `taskman` to your plugins list in `~/.zshrc`:

   ```bash
   plugins=(git taskman)
   ```

2. Reload your shell:

   ```bash
   source ~/.zshrc
   ```

3. Start using!

   ```bash
   tasks add "My first task"
   ```

## Requirements

- **Python 3.6+** (for interactive UI and CLI operations)
- **Terminal with color support** (most modern terminals)

## Usage

### Interactive UI

Launch the full-screen task manager:

```bash
tasks           # Launch interactive UI
tasks ui        # Same as above
task-sidebar    # Launch with sidebar usage tips
```

#### Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `↑`/`k` | Move up |
| `↓`/`j` | Move down |
| `n` | Create new task |
| `Space` | Toggle task completion |
| `d` | Delete selected task |
| `Tab` | Cycle priority when creating tasks |
| `h` | Toggle help panel |
| `q` | Quit |

### Command Line Interface

#### Adding Tasks

```bash
tasks add "Fix login bug"                    # Normal priority
tasks add "Deploy to production" high        # High priority
tasks add "Update documentation" low         # Low priority
```

#### Listing Tasks

```bash
tasks list           # All tasks
tasks list pending   # Only pending tasks
tasks list completed # Only completed tasks
tasks ls            # Short alias
```

#### Managing Tasks

```bash
tasks done 3         # Mark task ID 3 as completed
tasks delete 5       # Delete task ID 5
tasks help          # Show help
```

### Aliases

The plugin provides convenient aliases:

```bash
tm add "Buy groceries"    # Same as 'tasks add'
task list               # Same as 'tasks list'
todo done 1             # Same as 'tasks done 1'
```

## Priority Levels

Tasks support three priority levels with color coding:

- **High Priority** (`!`) - 🔴 Red, for urgent tasks
- **Normal Priority** (`-`) - 🟡 Yellow, default priority
- **Low Priority** (`·`) - 🔵 Cyan, for less urgent tasks

## Task Display

Tasks are displayed with visual indicators:

```
 ✓ [!] Completed high priority task     (green)
 ○ [-] Pending normal priority task     (yellow)
 ○ [·] Pending low priority task        (cyan)
```

## Sidebar Workflow

Perfect for split-terminal development workflow:

1. **Split your terminal** horizontally or vertically
2. **Run `tasks ui`** in one pane for persistent task view
3. **Work in the other pane** while keeping tasks visible
4. **Quick updates** with keyboard shortcuts

## Auto-completion

The plugin provides intelligent tab completion:

```bash
tasks <TAB>              # Shows: add, list, done, delete, etc.
tasks add "task" <TAB>   # Shows: high, normal, low
tasks done <TAB>        # Shows available task IDs
```

## Configuration

### Optional Startup Summary

To show task summary when opening terminal, uncomment this line in the plugin:

```bash
# In ~/.oh-my-zsh/plugins/taskman/taskman.plugin.zsh
_taskman_startup_summary  # Uncomment this line
```

This shows:
```
📋 Task Summary: 3 pending, 2 completed
   Type 'tasks' to manage your tasks
```

## Data Storage

Tasks are stored in `~/.taskman/tasks.json`:

```json
{
  "tasks": [
    {
      "id": 1,
      "text": "Fix login bug",
      "completed": false,
      "priority": "high",
      "created_at": "2024-01-15T10:30:00"
    }
  ],
  "next_id": 2
}
```

## Examples

### Daily Developer Workflow

```bash
# Morning planning
tasks add "Review PR #123" high
tasks add "Fix login bug" high  
tasks add "Update docs" low

# Check current tasks
tasks list pending

# Work in interactive mode (split terminal)
tasks ui

# Quick CLI updates
tm done 1
tm add "Deploy hotfix" high

# End of day review
tasks list completed
```

### Project Management

```bash
# Sprint planning
tasks add "Implement user auth" high
tasks add "Add unit tests" normal
tasks add "Update README" low

# Track progress
tasks list

# Mark completed
tasks done 1
tasks done 2

# Cleanup
tasks delete 3  # Remove completed/outdated tasks
```

## Comparison with Alternatives

| Feature | taskman | taskwarrior | todo.txt | Todoist |
|---------|---------|-------------|----------|----------|
| Interactive TUI | ✅ | ❌ | ❌ | ❌ |
| CLI Interface | ✅ | ✅ | ✅ | ✅ |
| Zero Setup | ✅ | ❌ | ✅ | ❌ |
| No External Deps | ✅ | ❌ | ✅ | ❌ |
| Rich Visual UI | ✅ | ❌ | ❌ | ❌ |
| Vim Keybindings | ✅ | ❌ | ❌ | ❌ |
| Local Data | ✅ | ✅ | ✅ | ❌ |

## Troubleshooting

### Python Not Found

```bash
# Install Python 3 (macOS)
brew install python3

# Install Python 3 (Ubuntu/Debian)
sudo apt-get install python3

# Verify installation
python3 --version
```

### Plugin Not Loading

1. Check that `taskman` is in your plugins list:
   ```bash
   echo $plugins
   ```

2. Reload your shell:
   ```bash
   source ~/.zshrc
   ```

3. Test plugin function:
   ```bash
   tasks help
   ```

### File Permissions

```bash
# Make Python files executable
chmod +x ~/.oh-my-zsh/plugins/taskman/bin/*.py
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see the [Oh-My-Zsh license](https://github.com/ohmyzsh/ohmyzsh/blob/master/LICENSE.txt) for details.

## Author

Created by [@oiahoon](https://github.com/oiahoon)

---

**Happy task managing! 🚀**

