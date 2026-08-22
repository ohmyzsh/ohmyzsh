# Autocompletion for the task CLI (task).
if (( !$+commands[task] )); then
  return
fi
# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `task`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_task" ]]; then
  typeset -g -A _comps
  autoload -Uz _task
  _comps[task]=_task
fi

# Generate and load task completion
{
  local completion="$ZSH_CACHE_DIR/completions/_task" tmp
  tmp=$(command mktemp "$completion.XXXXXX") || exit
  task --completion zsh >| "$tmp" && command mv -f "$tmp" "$completion"
  command rm -f "$tmp"
} &|
