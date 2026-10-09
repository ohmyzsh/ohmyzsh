# Autocompletion for talosctl
if (( ! $+commands[talosctl] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `talosctl`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_talosctl" ]]; then
  typeset -g -A _comps
  autoload -Uz _talosctl
  _comps[talosctl]=_talosctl
fi

talosctl completion zsh >| "$ZSH_CACHE_DIR/completions/_talosctl" &|
