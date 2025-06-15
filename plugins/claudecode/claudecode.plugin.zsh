# ClaudeCode CLI plugin for Oh My Zsh
# Provides autocompletion for the Claude Code command-line interface

# Check if claude command exists
if (( ! $+commands[claude] )); then
  return
fi

# Create cache directory if it doesn't exist
[[ ! -d "$ZSH_CACHE_DIR" ]] && mkdir -p "$ZSH_CACHE_DIR"

# Define cache files
_CLAUDECODE_COMPLETION_CACHE="$ZSH_CACHE_DIR/completions/_claude"
_CLAUDECODE_VERSION_CACHE="$ZSH_CACHE_DIR/claudecode_version"

# Function to get claude version
_claudecode_get_version() {
  claude --version 2>/dev/null | head -n1 || echo "unknown"
}

# Function to check if cache is valid
_claudecode_cache_valid() {
  [[ -f "$_CLAUDECODE_COMPLETION_CACHE" ]] && [[ -f "$_CLAUDECODE_VERSION_CACHE" ]] &&
  [[ "$(_claudecode_get_version)" == "$(cat "$_CLAUDECODE_VERSION_CACHE" 2>/dev/null)" ]]
}

# Function to generate completion cache
_claudecode_generate_completion() {
  local current_version="$(_claudecode_get_version)"

  # Create completions directory if it doesn't exist
  [[ ! -d "$ZSH_CACHE_DIR/completions" ]] && mkdir -p "$ZSH_CACHE_DIR/completions"

  # Create the completion function
  cat > "$_CLAUDECODE_COMPLETION_CACHE" << 'EOF'
#compdef claude

_claude() {
  local context state line
  typeset -A opt_args

  _arguments -C \
    '(-p --print)'{-p,--print}'[Print response without interactive mode]' \
    '(-c --continue)'{-c,--continue}'[Continue most recent conversation]' \
    '(-r --resume)'{-r,--resume}'[Resume session by ID]:session-id:_claude_session_ids' \
    '--model[Set model for current session]:model:(sonnet opus claude-3-5-sonnet-20241022 claude-3-opus-20240229 claude-3-haiku-20240307)' \
    '--add-dir[Add additional working directories]:directory:_directories' \
    '--allowedTools[List of tools allowed without prompting]:tools:_claude_tools' \
    '--disallowedTools[List of tools disallowed without prompting]:tools:_claude_tools' \
    '--output-format[Specify output format for print mode]:format:(text json stream-json)' \
    '--input-format[Specify input format for print mode]:format:(text stream-json)' \
    '--verbose[Enable verbose logging]' \
    '--max-turns[Limit number of agentic turns]:number:' \
    '--permission-prompt-tool[Specify MCP tool for permission prompts]:tool:' \
    '--dangerously-skip-permissions[Skip permission prompts (use with caution)]' \
    '(-h --help)'{-h,--help}'[Show help information]' \
    '(-v --version)'{-v,--version}'[Show version information]' \
    '*::query or subcommand:_claude_commands'
}

_claude_commands() {
  local -a commands
  commands=(
    'update:Update to latest version'
    'mcp:Configure Model Context Protocol servers'
    'commit:Create a commit with AI assistance'
    'pr:Create a pull request'
    'review:Review code changes'
    'test:Run and fix tests'
    'lint:Run and fix linting issues'
    'docs:Generate or update documentation'
  )

  if (( CURRENT == 1 )); then
    _alternative \
      'commands:subcommands:compadd -a commands' \
      'queries:query string:_message "query string"'
  else
    case $words[1] in
      update)
        _message "no more arguments"
        ;;
      mcp)
        _message "MCP configuration options"
        ;;
      commit|pr|review|test|lint|docs)
        _message "additional options or query"
        ;;
      *)
        _message "query string"
        ;;
    esac
  fi
}

# Helper function for session ID completion
_claude_session_ids() {
  local -a sessions
  # Try to get session IDs from claude history (if available)
  if command -v claude >/dev/null 2>&1; then
    sessions=($(claude --list-sessions 2>/dev/null | grep -o '^[a-zA-Z0-9]\+' || echo))
  fi

  if [[ ${#sessions[@]} -gt 0 ]]; then
    _describe 'session IDs' sessions
  else
    _message "session ID"
  fi
}

# Helper function for tool completion
_claude_tools() {
  local -a tools
  tools=(
    'Bash:Execute bash commands'
    'Write:Write or edit files'
    'Read:Read file contents'
    'Search:Search through files'
    'Git:Git operations'
    'WebSearch:Search the web'
  )

  _describe 'tools' tools
}

EOF

  # Save current version to cache
  echo "$current_version" > "$_CLAUDECODE_VERSION_CACHE"
}

# Initialize completion
if ! _claudecode_cache_valid; then
  _claudecode_generate_completion
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `claude`. Otherwise, compinit will have already done that.
if [[ ! -f "$_CLAUDECODE_COMPLETION_CACHE" ]]; then
  typeset -g -A _comps
  autoload -Uz _claude
  _comps[claude]=_claude
fi

# Load the completion
if [[ -f "$_CLAUDECODE_COMPLETION_CACHE" ]]; then
  source "$_CLAUDECODE_COMPLETION_CACHE"
fi

# Useful aliases for ClaudeCode
alias cc='claude'
alias ccp='claude -p'
alias ccc='claude -c'
alias ccr='claude -r'
alias ccv='claude --verbose'
alias ccu='claude update'
alias ccm='claude mcp'

# Git-related aliases
alias cccommit='claude commit'
alias ccpr='claude pr'
alias ccreview='claude review'

# Development aliases
alias cctest='claude test'
alias cclint='claude lint'
alias ccdocs='claude docs'

# Model-specific aliases
alias ccsonnet='claude --model sonnet'
alias ccopus='claude --model opus'
alias cchaiku='claude --model claude-3-haiku-20240307'

# Function to quickly start claude with common patterns
claude-quick() {
  case "$1" in
    explain)
      shift
      claude -p "Explain this: $*"
      ;;
    debug)
      shift
      claude -p "Debug this code: $*"
      ;;
    review)
      shift
      claude -p "Review this code: $*"
      ;;
    fix)
      shift
      claude -p "Fix this issue: $*"
      ;;
    optimize)
      shift
      claude -p "Optimize this code: $*"
      ;;
    refactor)
      shift
      claude -p "Refactor this code: $*"
      ;;
    test)
      shift
      claude -p "Write tests for: $*"
      ;;
    docs)
      shift
      claude -p "Write documentation for: $*"
      ;;
    *)
      echo "Usage: claude-quick {explain|debug|review|fix|optimize|refactor|test|docs} <content>"
      echo "Examples:"
      echo "  claude-quick explain 'function definition'"
      echo "  claude-quick debug 'error message'"
      echo "  claude-quick review 'code snippet'"
      echo "  claude-quick fix 'bug description'"
      echo "  claude-quick optimize 'slow function'"
      echo "  claude-quick refactor 'legacy code'"
      echo "  claude-quick test 'new feature'"
      echo "  claude-quick docs 'API endpoint'"
      ;;
  esac
}

# Function to pipe content to claude
claude-pipe() {
  if [[ -p /dev/stdin ]]; then
    # Data is being piped
    cat | claude -p "$*"
  else
    echo "Usage: command | claude-pipe 'your query'"
    echo "Example: cat file.js | claude-pipe 'explain this code'"
  fi
}

# Completion for claude-quick function
_claude_quick() {
  local -a actions
  actions=(
    'explain:Explain the given content'
    'debug:Debug the given code or error'
    'review:Review the given code'
    'fix:Fix the given issue'
    'optimize:Optimize the given code'
    'refactor:Refactor the given code'
    'test:Write tests for the given code'
    'docs:Write documentation for the given code'
  )

  _describe 'actions' actions
}

# Git integration functions
claude-git() {
  case "$1" in
    commit)
      shift
      if [[ -n "$*" ]]; then
        claude -p "Create a commit message for these changes: $*"
      else
        claude commit
      fi
      ;;
    pr)
      shift
      if [[ -n "$*" ]]; then
        claude -p "Create a pull request description for: $*"
      else
        claude pr
      fi
      ;;
    diff)
      shift
      git diff "$@" | claude-pipe "explain these changes"
      ;;
    log)
      shift
      git log --oneline -10 "$@" | claude-pipe "summarize these commits"
      ;;
    conflicts)
      git status --porcelain | grep "^UU" | claude-pipe "help resolve these merge conflicts"
      ;;
    *)
      echo "Usage: claude-git {commit|pr|diff|log|conflicts} [options]"
      echo "Examples:"
      echo "  claude-git commit 'added new feature'"
      echo "  claude-git pr 'bug fix for authentication'"
      echo "  claude-git diff HEAD~1"
      echo "  claude-git log --author='john'"
      echo "  claude-git conflicts"
      ;;
  esac
}

# Project analysis functions
claude-project() {
  case "$1" in
    analyze)
      claude -p "Analyze this project structure and provide insights"
      ;;
    deps)
      if [[ -f "package.json" ]]; then
        cat package.json | claude-pipe "analyze these dependencies and suggest improvements"
      elif [[ -f "requirements.txt" ]]; then
        cat requirements.txt | claude-pipe "analyze these Python dependencies"
      elif [[ -f "Cargo.toml" ]]; then
        cat Cargo.toml | claude-pipe "analyze these Rust dependencies"
      else
        echo "No recognized dependency file found"
      fi
      ;;
    security)
      claude -p "Perform a security audit of this project"
      ;;
    performance)
      claude -p "Analyze this project for performance improvements"
      ;;
    architecture)
      claude -p "Review the architecture of this project and suggest improvements"
      ;;
    *)
      echo "Usage: claude-project {analyze|deps|security|performance|architecture}"
      echo "Examples:"
      echo "  claude-project analyze"
      echo "  claude-project deps"
      echo "  claude-project security"
      echo "  claude-project performance"
      echo "  claude-project architecture"
      ;;
  esac
}

# Session management functions
claude-session() {
  case "$1" in
    list)
      claude --list-sessions 2>/dev/null || echo "Session listing not available"
      ;;
    save)
      shift
      local session_name="${1:-$(date +%Y%m%d_%H%M%S)}"
      echo "Saving current session as: $session_name"
      # This would need actual implementation based on Claude's session management
      ;;
    load)
      shift
      if [[ -n "$1" ]]; then
        claude -r "$1"
      else
        echo "Usage: claude-session load <session-id>"
      fi
      ;;
    clean)
      echo "Cleaning old sessions..."
      # This would need actual implementation
      ;;
    *)
      echo "Usage: claude-session {list|save|load|clean} [options]"
      echo "Examples:"
      echo "  claude-session list"
      echo "  claude-session save my_project_session"
      echo "  claude-session load abc123"
      echo "  claude-session clean"
      ;;
  esac
}

# Enhanced pipe function with preprocessing
claude-pipe-enhanced() {
  local format="$1"
  shift

  if [[ -p /dev/stdin ]]; then
    case "$format" in
      code)
        cat | claude -p "Analyze this code: $*"
        ;;
      log)
        cat | claude -p "Analyze this log file: $*"
        ;;
      error)
        cat | claude -p "Help debug this error: $*"
        ;;
      json)
        cat | claude -p "Analyze this JSON data: $*"
        ;;
      *)
        cat | claude -p "$format $*"
        ;;
    esac
  else
    echo "Usage: command | claude-pipe-enhanced {code|log|error|json|<custom>} 'your query'"
    echo "Examples:"
    echo "  cat app.js | claude-pipe-enhanced code 'explain this function'"
    echo "  tail -f error.log | claude-pipe-enhanced log 'find issues'"
    echo "  npm test 2>&1 | claude-pipe-enhanced error 'fix failing tests'"
    echo "  curl api/data | claude-pipe-enhanced json 'summarize this data'"
  fi
}

# Completion for new functions
_claude_git() {
  local -a actions
  actions=(
    'commit:Create commit message or commit with AI'
    'pr:Create pull request description'
    'diff:Explain git diff output'
    'log:Summarize git log'
    'conflicts:Help resolve merge conflicts'
  )
  _describe 'git actions' actions
}

_claude_project() {
  local -a actions
  actions=(
    'analyze:Analyze project structure'
    'deps:Analyze dependencies'
    'security:Security audit'
    'performance:Performance analysis'
    'architecture:Architecture review'
  )
  _describe 'project actions' actions
}

_claude_session() {
  local -a actions
  actions=(
    'list:List available sessions'
    'save:Save current session'
    'load:Load a session'
    'clean:Clean old sessions'
  )
  _describe 'session actions' actions
}

_claude_pipe_enhanced() {
  local -a formats
  formats=(
    'code:Analyze as code'
    'log:Analyze as log file'
    'error:Analyze as error output'
    'json:Analyze as JSON data'
  )
  _describe 'input formats' formats
}

compdef _claude_quick claude-quick
compdef _claude_git claude-git
compdef _claude_project claude-project
compdef _claude_session claude-session
compdef _claude_pipe_enhanced claude-pipe-enhanced
