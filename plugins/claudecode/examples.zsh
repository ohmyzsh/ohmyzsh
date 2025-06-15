#!/usr/bin/env zsh

# ClaudeCode Plugin Usage Examples
# This file demonstrates various ways to use the ClaudeCode Oh My Zsh plugin

echo "🚀 ClaudeCode Plugin Usage Examples"
echo "===================================="

# Basic usage examples
echo "📝 Basic Usage:"
echo "  cc                                    # Start interactive Claude session"
echo "  ccp 'explain this function'          # Quick print mode"
echo "  ccc                                   # Continue last conversation"
echo "  ccr abc123                           # Resume specific session"
echo "  ccv 'debug this with verbose output' # Verbose mode"
echo ""

# Model selection examples
echo "🤖 Model Selection:"
echo "  ccsonnet 'use Sonnet model'          # Use Claude Sonnet"
echo "  ccopus 'use Opus model'              # Use Claude Opus"
echo "  cchaiku 'use Haiku model'            # Use Claude Haiku"
echo "  cc --model claude-3-5-sonnet-20241022 'specific model version'"
echo ""

# Git integration examples
echo "🔧 Git Integration:"
echo "  claude-git commit                     # AI-assisted commit"
echo "  claude-git pr 'bug fix description'  # Create PR description"
echo "  claude-git diff HEAD~1               # Explain git diff"
echo "  claude-git log --author='john'       # Summarize commits"
echo "  claude-git conflicts                 # Help resolve conflicts"
echo ""

# Quick patterns examples
echo "⚡ Quick Patterns:"
echo "  claude-quick explain 'async/await'   # Explain concepts"
echo "  claude-quick debug 'error message'   # Debug issues"
echo "  claude-quick review 'code snippet'   # Code review"
echo "  claude-quick fix 'bug description'   # Fix problems"
echo "  claude-quick optimize 'slow query'   # Optimize code"
echo "  claude-quick refactor 'legacy code'  # Refactor code"
echo "  claude-quick test 'new feature'      # Write tests"
echo "  claude-quick docs 'API endpoint'     # Write docs"
echo ""

# Pipe examples
echo "🔄 Pipe Operations:"
echo "  cat app.js | claude-pipe 'explain this code'"
echo "  git log --oneline | claude-pipe 'summarize commits'"
echo "  npm test 2>&1 | claude-pipe 'fix failing tests'"
echo ""

# Enhanced pipe examples
echo "🔄 Enhanced Pipe Operations:"
echo "  cat app.js | claude-pipe-enhanced code 'find bugs'"
echo "  tail -f error.log | claude-pipe-enhanced log 'analyze errors'"
echo "  npm test 2>&1 | claude-pipe-enhanced error 'fix tests'"
echo "  curl api/data | claude-pipe-enhanced json 'summarize data'"
echo ""

# Project analysis examples
echo "📊 Project Analysis:"
echo "  claude-project analyze              # Full project analysis"
echo "  claude-project deps                 # Dependency analysis"
echo "  claude-project security             # Security audit"
echo "  claude-project performance          # Performance review"
echo "  claude-project architecture         # Architecture review"
echo ""

# Session management examples
echo "💾 Session Management:"
echo "  claude-session list                 # List sessions"
echo "  claude-session save my_work         # Save current session"
echo "  claude-session load abc123          # Load session"
echo "  claude-session clean                # Clean old sessions"
echo ""

# Advanced usage examples
echo "🎯 Advanced Usage:"
echo "  # Combine multiple flags"
echo "  cc --model sonnet --verbose --add-dir ../lib 'analyze project'"
echo ""
echo "  # Use with output formatting"
echo "  ccp --output-format json 'get project stats' | jq '.'"
echo ""
echo "  # Chain operations"
echo "  git diff --cached | claude-pipe-enhanced code 'review changes' && claude-git commit"
echo ""

# Workflow examples
echo "🔄 Common Workflows:"
echo ""
echo "  # Code Review Workflow:"
echo "  git diff --cached | claude-pipe-enhanced code 'review these changes'"
echo "  claude-git commit"
echo "  claude-git pr 'description of changes'"
echo ""
echo "  # Debugging Workflow:"
echo "  npm test 2>&1 | claude-pipe-enhanced error 'analyze test failures'"
echo "  claude-quick fix 'specific error from above'"
echo "  npm test  # Run tests again"
echo ""
echo "  # Project Setup Workflow:"
echo "  claude-project analyze"
echo "  claude-project deps"
echo "  claude-project security"
echo "  claude-quick docs 'setup instructions'"
echo ""

# Tips and tricks
echo "💡 Tips and Tricks:"
echo ""
echo "  # Use Tab completion for all commands and flags"
echo "  cc --<TAB>                          # See all available flags"
echo "  claude-quick <TAB>                  # See all quick actions"
echo "  claude-git <TAB>                    # See all git actions"
echo ""
echo "  # Combine with other tools"
echo "  watch -n 5 'npm test 2>&1 | claude-pipe-enhanced error \"monitor tests\"'"
echo ""
echo "  # Save frequently used queries"
echo "  alias ccbug='claude-quick debug'"
echo "  alias ccopt='claude-quick optimize'"
echo ""

echo "📚 For more information, see the README.md file or visit:"
echo "   https://docs.anthropic.com/en/docs/claude-code/"
