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

# Helm ls
alias hls='helm ls'
alias hlsa='helm ls --all'
alias hlsn='helm ls --namespace'

# Helm get
alias hget='helm get'
alias hgeta='helm get all'
alias hgetn='helm get --namespace'
alias hgetan='helm get all --namespace'

# Helm delete
alias hdel='helm delete'
alias hdeln='helm delete --namespace'

# Helm depedency
alias hdep='helm dependency'
alias hdepb='helm dependency build'

# Helm install
alias hinst='helm install'
alias hinstn='helm install --namespace'
alias hinstc='helm install --name'
alias hinstnc='helm install --namespace --name'
alias hinstf='helm install --values'
alias hinstfn='helm install --values --namespace'
alias hinstfnc='helm install --values --namespace --name'

# Helm upgrade
alias hup='helm upgrade'
alias hupf='helm upgrade --values'

# Helm repo
alias hrep='helm repo'
alias hrepl='helm repo list'
alias hrepu='helm repo update'
alias hrepa='helm repo add'

# Helm search
alias hse='helm search'
alias hseh='helm search hub'
alias hser='helm search repo'

# Helm status
alias hsta='helm status'

# Helm template
alias htem='helm template'
alias htemn='helm template --namespace'

# Helm test
alias htes='helm test'
alias htesn='helm test --namespace'

# Helm version
alias hver='helm version'

# Helm lint
alias hlin='helm lint'

# Helm package
alias hpack='helm package'
alias hpackn='helm package --namespace'

# Helm rollback
alias hrol='helm rollback'
alias hroln='helm rollback --namespace'

# Helm plugin
alias hplug='helm plugin'
alias hplugl='helm plugin list'
alias hplugi='helm plugin install'
alias hplugu='helm plugin uninstall'
alias hplugln='helm plugin list --namespace'
alias hplugin='helm plugin install --namespace'
alias hplugun='helm plugin uninstall --namespace'

# Helm create
alias hcre='helm create'
alias hcren='helm create --namespace'

# Helm env
alias henv='helm env'

# Helm uninstall
alias huni='helm uninstall'
alias hunin='helm uninstall --namespace'

# Helm history
alias hhis='helm history'
alias hhisn='helm history --namespace'

# Helm verify
alias hver='helm verify'
alias hvern='helm verify --namespace'

# Helm show
alias hsho='helm show'
alias hshoa='helm show all'
alias hshon='helm show --namespace'
alias hshoan='helm show all --namespace'
