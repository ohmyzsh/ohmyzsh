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
  helm completion zsh | tee "$ZSH_CACHE_DIR/completions/_helm" >/dev/null &|
fi

alias h='helm'
alias hco='helm completion'
alias hct='helm create'
alias hde='helm delete'
alias hen='helm env'
alias hgm='helm get manifest'
alias hhp='helm help'
alias hid='helm install --debug --dry-run'
alias hin='helm install'
alias hls='helm list'
alias hlt='helm lint'
alias hpl='helm pull'
alias hps='helm push'
alias hra='helm repo add'
alias hrb='helm rollback'
alias hrr='helm repo remove'
alias hru='helm repo update'
alias hse='helm search'
alias hsh='helm show'
alias hss='helm satuts'
alias hst='helm history'
alias hte='helm template'
alias htt='helm test'
alias hui='helm upgrade -i'
alias hun='helm uninstall'
alias hup='helm upgrade'
alias hvn='helm version'
alias hvy='helm verify'
  