# ClaudeCode Plugin for Oh My Zsh

This plugin provides autocompletion and useful aliases for the [Claude Code CLI](https://claude.ai/code), making it easier to interact with Claude from the command line.

## Features

### Autocompletion
- Complete all Claude Code CLI commands and flags
- Smart completion for subcommands (`update`, `mcp`, `commit`, `pr`, `review`, `test`, `lint`, `docs`)
- Model name completion (`sonnet`, `opus`, `claude-3-5-sonnet-20241022`, `claude-3-opus-20240229`, `claude-3-haiku-20240307`)
- Output format completion (`text`, `json`, `stream-json`)
- Directory completion for `--add-dir` flag
- Session ID completion for `--resume` flag
- Tool completion for `--allowedTools` and `--disallowedTools`
- Enhanced flag completion with short forms (`-h`, `-v`, `-p`, `-c`, `-r`)

### Aliases

#### Basic Aliases
- `cc` → `claude` (short alias for quick access)
- `ccp` → `claude -p` (print mode)
- `ccc` → `claude -c` (continue conversation)
- `ccr` → `claude -r` (resume session)
- `ccv` → `claude --verbose` (verbose mode)
- `ccu` → `claude update` (update Claude Code)
- `ccm` → `claude mcp` (MCP configuration)

#### Git Integration Aliases
- `cccommit` → `claude commit` (AI-assisted commits)
- `ccpr` → `claude pr` (AI-assisted pull requests)
- `ccreview` → `claude review` (code review)

#### Development Aliases
- `cctest` → `claude test` (test-related tasks)
- `cclint` → `claude lint` (linting tasks)
- `ccdocs` → `claude docs` (documentation tasks)

#### Model-Specific Aliases
- `ccsonnet` → `claude --model sonnet` (use Sonnet model)
- `ccopus` → `claude --model opus` (use Opus model)
- `cchaiku` → `claude --model claude-3-haiku-20240307` (use Haiku model)

### Helper Functions

#### `claude-quick`
Quick access to common Claude Code patterns:

```bash
claude-quick explain "function definition"
claude-quick debug "error message"
claude-quick review "code snippet"
claude-quick fix "bug description"
claude-quick optimize "slow function"
claude-quick refactor "legacy code"
claude-quick test "new feature"
claude-quick docs "API endpoint"
```

#### `claude-pipe`
Pipe content directly to Claude:

```bash
cat file.js | claude-pipe "explain this code"
git log --oneline | claude-pipe "summarize these commits"
```

#### `claude-pipe-enhanced`
Enhanced pipe function with format-specific preprocessing:

```bash
cat app.js | claude-pipe-enhanced code "explain this function"
tail -f error.log | claude-pipe-enhanced log "find issues"
npm test 2>&1 | claude-pipe-enhanced error "fix failing tests"
curl api/data | claude-pipe-enhanced json "summarize this data"
```

#### `claude-git`
Git integration functions:

```bash
claude-git commit "added new feature"    # Create commit with AI
claude-git pr "bug fix description"      # Create PR description
claude-git diff HEAD~1                   # Explain git diff
claude-git log --author="john"           # Summarize commits
claude-git conflicts                     # Help resolve conflicts
```

#### `claude-project`
Project analysis functions:

```bash
claude-project analyze        # Analyze project structure
claude-project deps          # Analyze dependencies
claude-project security      # Security audit
claude-project performance   # Performance analysis
claude-project architecture  # Architecture review
```

#### `claude-session`
Session management functions:

```bash
claude-session list                    # List available sessions
claude-session save my_project_session # Save current session
claude-session load abc123            # Load specific session
claude-session clean                  # Clean old sessions
```

## Installation

### Using Oh My Zsh

1. Clone this repository into your Oh My Zsh custom plugins directory:
   ```bash
   git clone https://github.com/your-username/ohmyzsh-claudecode-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/claudecode
   ```

2. Add `claudecode` to your plugins array in `~/.zshrc`:
   ```bash
   plugins=(... claudecode)
   ```

3. Restart your terminal or run:
   ```bash
   source ~/.zshrc
   ```

### Manual Installation

1. Download the `claudecode.plugin.zsh` file
2. Source it in your `~/.zshrc`:
   ```bash
   source /path/to/claudecode.plugin.zsh
   ```

## Requirements

- [Claude Code CLI](https://claude.ai/code) must be installed and available in your PATH
- Oh My Zsh (for plugin installation method)
- Zsh with completion support

## Usage Examples

### Basic Commands with Completion
```bash
# Start interactive session (press Tab for completion)
claude <Tab>

# Print mode with flags (press Tab after --)
claude -p --<Tab>

# Continue with model selection
claude -c --model <Tab>

# Resume specific session
claude -r <session-id> <Tab>
```

### Using Aliases
```bash
# Quick print mode
ccp "explain this function"

# Continue previous conversation
ccc

# Verbose mode
ccv "debug this issue"

# Update Claude Code
ccu
```

### Using Helper Functions
```bash
# Quick patterns
claude-quick explain "async/await in JavaScript"
claude-quick debug "TypeError: Cannot read property"
claude-quick review "this React component"
claude-quick fix "memory leak in my application"
claude-quick optimize "database query performance"
claude-quick refactor "legacy authentication code"
claude-quick test "user registration flow"
claude-quick docs "REST API endpoints"

# Pipe content
cat error.log | claude-pipe "what's causing this error?"
ps aux | claude-pipe "which processes are using too much memory?"

# Enhanced pipe with format detection
cat app.js | claude-pipe-enhanced code "find potential bugs"
tail -100 /var/log/nginx/error.log | claude-pipe-enhanced log "analyze errors"
npm test 2>&1 | claude-pipe-enhanced error "fix these test failures"

# Git integration
claude-git commit                    # AI-assisted commit
claude-git pr "fixes authentication bug"
claude-git diff --cached            # Explain staged changes
claude-git log --since="1 week ago" # Summarize recent work
claude-git conflicts                # Help with merge conflicts

# Project analysis
claude-project analyze              # Full project analysis
claude-project deps                # Dependency analysis
claude-project security            # Security audit
claude-project performance         # Performance review

# Session management
claude-session list                 # Show available sessions
claude-session save feature_work    # Save current session
claude-session load abc123          # Resume specific session
```

## Cache Management

The plugin automatically caches completion data for better performance:

- Cache location: `$ZSH_CACHE_DIR/completions/_claude`
- Version tracking: `$ZSH_CACHE_DIR/claudecode_version`
- Automatic cache invalidation when Claude Code is updated

## Troubleshooting

### Completion not working
1. Ensure Claude Code CLI is installed: `which claude`
2. Verify the plugin is loaded: `which cc` (should show the alias)
3. Reload completions: `compinit`

### Cache issues
1. Clear the cache:
   ```bash
   rm -f "$ZSH_CACHE_DIR/completions/_claude"
   rm -f "$ZSH_CACHE_DIR/claudecode_version"
   ```
2. Restart your terminal

### Permission issues
If you encounter permission prompts frequently, consider using:
```bash
claude --dangerously-skip-permissions -p "your query"
```
**Note**: Use with caution as this bypasses security prompts.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with different Claude Code versions
5. Submit a pull request

## License

This plugin is released under the MIT License.

## Related

- [Claude Code Documentation](https://claude.ai/code)
- [Oh My Zsh](https://ohmyz.sh/)
- [Zsh Completion System](http://zsh.sourceforge.net/Doc/Release/Completion-System.html)
