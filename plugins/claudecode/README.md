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
