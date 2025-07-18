#!/usr/bin/env zsh

# Test script for ClaudeCode Oh My Zsh plugin
# This script tests the basic functionality of the plugin

echo "🧪 Testing ClaudeCode Oh My Zsh Plugin"
echo "======================================"

# Set up test environment
export ZSH_CACHE_DIR="/tmp/test_claudecode_cache"
mkdir -p "$ZSH_CACHE_DIR"

# Source the plugin
echo "📦 Loading plugin..."
source "./claudecode.plugin.zsh"

# Test 1: Check if aliases are defined
echo "🔍 Testing aliases..."
test_aliases() {
  local aliases=("cc" "ccp" "ccc" "ccr" "ccv" "ccu" "ccm" "cccommit" "ccpr" "ccreview" "cctest" "cclint" "ccdocs" "ccsonnet" "ccopus" "cchaiku")
  local failed=0

  for alias_name in "${aliases[@]}"; do
    if alias "$alias_name" >/dev/null 2>&1; then
      echo "  ✅ Alias '$alias_name' is defined"
    else
      echo "  ❌ Alias '$alias_name' is NOT defined"
      ((failed++))
    fi
  done

  return $failed
}

# Test 2: Check if functions are defined
echo "🔍 Testing functions..."
test_functions() {
  local functions=("claude-quick" "claude-pipe" "claude-git" "claude-project" "claude-session" "claude-pipe-enhanced" "_claude_quick" "_claude_git" "_claude_project" "_claude_session")
  local failed=0

  for func_name in "${functions[@]}"; do
    if declare -f "$func_name" >/dev/null 2>&1; then
      echo "  ✅ Function '$func_name' is defined"
    else
      echo "  ❌ Function '$func_name' is NOT defined"
      ((failed++))
    fi
  done

  return $failed
}

# Test 3: Test claude-quick function
echo "🔍 Testing claude-quick function..."
test_claude_quick() {
  local output
  output=$(claude-quick 2>&1)

  if [[ $output == *"Usage: claude-quick"* ]]; then
    echo "  ✅ claude-quick shows usage when called without arguments"
    return 0
  else
    echo "  ❌ claude-quick does not show expected usage message"
    return 1
  fi
}

# Test 4: Test claude-pipe function
echo "🔍 Testing claude-pipe function..."
test_claude_pipe() {
  local output
  output=$(claude-pipe 2>&1)

  if [[ $output == *"Usage: command | claude-pipe"* ]]; then
    echo "  ✅ claude-pipe shows usage when called without pipe"
    return 0
  else
    echo "  ❌ claude-pipe does not show expected usage message"
    return 1
  fi
}

# Test 5: Check if completion cache functions exist
echo "🔍 Testing cache functions..."
test_cache_functions() {
  local functions=("_claudecode_get_version" "_claudecode_cache_valid" "_claudecode_generate_completion")
  local failed=0

  for func_name in "${functions[@]}"; do
    if declare -f "$func_name" >/dev/null 2>&1; then
      echo "  ✅ Cache function '$func_name' is defined"
    else
      echo "  ❌ Cache function '$func_name' is NOT defined"
      ((failed++))
    fi
  done

  return $failed
}

# Test 6: Test completion generation (mock)
echo "🔍 Testing completion generation..."
test_completion_generation() {
  # Mock claude command for testing
  claude() {
    echo "Claude Code CLI v1.0.0"
  }

  # Test version function
  local version
  version=$(_claudecode_get_version)

  if [[ -n "$version" ]]; then
    echo "  ✅ Version detection works: $version"
    return 0
  else
    echo "  ❌ Version detection failed"
    return 1
  fi
}

# Run all tests
echo ""
echo "🚀 Running tests..."
echo ""

failed_tests=0

test_aliases
((failed_tests += $?))

test_functions
((failed_tests += $?))

test_claude_quick
((failed_tests += $?))

test_claude_pipe
((failed_tests += $?))

test_cache_functions
((failed_tests += $?))

test_completion_generation
((failed_tests += $?))

# Test 7: Test new helper functions
echo "🔍 Testing new helper functions..."
test_new_functions() {
  local failed=0

  # Test claude-git function
  local output
  output=$(claude-git 2>&1)
  if [[ $output == *"Usage: claude-git"* ]]; then
    echo "  ✅ claude-git shows usage when called without arguments"
  else
    echo "  ❌ claude-git does not show expected usage message"
    ((failed++))
  fi

  # Test claude-project function
  output=$(claude-project 2>&1)
  if [[ $output == *"Usage: claude-project"* ]]; then
    echo "  ✅ claude-project shows usage when called without arguments"
  else
    echo "  ❌ claude-project does not show expected usage message"
    ((failed++))
  fi

  # Test claude-session function
  output=$(claude-session 2>&1)
  if [[ $output == *"Usage: claude-session"* ]]; then
    echo "  ✅ claude-session shows usage when called without arguments"
  else
    echo "  ❌ claude-session does not show expected usage message"
    ((failed++))
  fi

  # Test claude-pipe-enhanced function
  output=$(claude-pipe-enhanced 2>&1)
  if [[ $output == *"Usage: command | claude-pipe-enhanced"* ]]; then
    echo "  ✅ claude-pipe-enhanced shows usage when called without pipe"
  else
    echo "  ❌ claude-pipe-enhanced does not show expected usage message"
    ((failed++))
  fi

  return $failed
}

test_new_functions
((failed_tests += $?))

# Summary
echo ""
echo "📊 Test Summary"
echo "==============="

if [[ $failed_tests -eq 0 ]]; then
  echo "🎉 All tests passed! The plugin is working correctly."
  exit 0
else
  echo "❌ $failed_tests test(s) failed. Please check the plugin implementation."
  exit 1
fi

# Cleanup
rm -rf "$ZSH_CACHE_DIR"
