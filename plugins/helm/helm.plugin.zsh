if (( ! $+commands[helm] )); then
  return
fi

# If the completion file does not exist, generate it and then source it
# Otherwise, source it and regenerate in the background
if [[ ! -f "$ZSH_CACHE_DIR/completions/_helm" ]]; then
  helm completion zsh | tee "$ZSH_CACHE_DIR/completions/_helm" >/dev/null
  source "$ZSH_CACHE_DIR/completions/_helm"
else
  source "$ZSH_CACHE_DIR/completions/_helm"
  # Regenerate atomically so a concurrent compinit never reads a partial file.
  local _helm_tmp="$ZSH_CACHE_DIR/completions/_helm.tmp.$$"
  helm completion zsh >| "$_helm_tmp" && mv -f "$_helm_tmp" "$ZSH_CACHE_DIR/completions/_helm" &|
fi

alias h='helm'
alias hin='helm install'
alias hun='helm uninstall'
alias hse='helm search'
alias hup='helm upgrade'
