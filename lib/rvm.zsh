# Get the name of the current branch.
function rvm_prompt_info() {
  local ruby_version=$(~/.rvm/bin/rvm-prompt 2> /dev/null)
  if [[ -n "$ruby_version" ]]; then
    echo "($ruby_version)"
  fi
}

