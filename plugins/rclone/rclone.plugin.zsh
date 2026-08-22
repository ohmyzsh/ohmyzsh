# Completion
if (( ! $+commands[rclone] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `rclone`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_rclone" ]]; then
  typeset -g -A _comps
  autoload -Uz _rclone
  _comps[rclone]=_rclone
fi

{
  local completion="$ZSH_CACHE_DIR/completions/_rclone" tmp
  tmp=$(command mktemp "$completion.XXXXXX") || exit
  rclone completion zsh - >| "$tmp" && command mv -f "$tmp" "$completion"
  command rm -f "$tmp"
} &|
