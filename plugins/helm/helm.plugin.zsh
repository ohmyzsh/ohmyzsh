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
  {
    local completion="$ZSH_CACHE_DIR/completions/_helm" tmp
    tmp=$(command mktemp -t _omz_comp.XXXXXXXX) || exit
    helm completion zsh >| "$tmp" && command mv -f "$tmp" "$completion"
    command rm -f "$tmp"
  } &|
fi

alias h='helm'
alias hin='helm install'
alias hun='helm uninstall'
alias hse='helm search'
alias hup='helm upgrade'
