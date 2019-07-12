if (( $+commands[kubectl] )); then
    __KUBECTL_COMPLETION_FILE="${ZSH_CACHE_DIR}/kubectl_completion"

    if [[ ! -f $__KUBECTL_COMPLETION_FILE ]]; then
        kubectl completion zsh >! $__KUBECTL_COMPLETION_FILE
    fi

    [[ -f $__KUBECTL_COMPLETION_FILE ]] && source $__KUBECTL_COMPLETION_FILE

    unset __KUBECTL_COMPLETION_FILE
fi

# This command is used a LOT both below and in daily life
alias k=kubectl

# Execute a kubectl command against all namespaces
alias kca='f(){ k "$@" --all-namespaces;  unset -f f; }; f'

# Apply a YML file
alias kaf='k apply -f'

# Drop into an interactive terminal on a container
alias keti='k exec -ti'

# Manage configuration quickly to switch contexts between local, dev ad staging.
alias kcuc='k config use-context'
alias kcsc='k config set-context'
alias kcdc='k config delete-context'
alias kccc='k config current-context'

# List all contexts
alias kcgc='k config get-contexts'

# General aliases
alias kdel='k delete'
alias kdelf='k delete -f'

# Pod management.
alias kgp='k get pods'
alias kgpw='kgp --watch'
alias kgpwide='kgp -o wide'
alias kep='k edit pods'
alias kdp='k describe pods'
alias kdelp='k delete pods'

# get pod by label: kgpl "app=myapp" -n myns
alias kgpl='kgp -l'

# Service management.
alias kgs='k get svc'
alias kgsw='kgs --watch'
alias kgswide='kgs -o wide'
alias kes='k edit svc'
alias kds='k describe svc'
alias kdels='k delete svc'

# Ingress management
alias kgi='k get ingress'
alias kei='k edit ingress'
alias kdi='k describe ingress'
alias kdeli='k delete ingress'

# Namespace management
alias kgns='k get namespaces'
alias kens='k edit namespace'
alias kdns='k describe namespace'
alias kdelns='k delete namespace'
alias kcn='k config set-context $(k config current-context) --namespace'

# ConfigMap management
alias kgcm='k get configmaps'
alias kecm='k edit configmap'
alias kdcm='k describe configmap'
alias kdelcm='k delete configmap'

# Secret management
alias kgsec='k get secret'
alias kdsec='k describe secret'
alias kdelsec='k delete secret'

# Deployment management.
alias kgd='k get deployment'
alias kgdw='kgd --watch'
alias kgdwide='kgd -o wide'
alias ked='k edit deployment'
alias kdd='k describe deployment'
alias kdeld='k delete deployment'
alias ksd='k scale deployment'
alias krsd='k rollout status deployment'
kres(){
    k set env $@ REFRESHED_AT=$(date +%Y%m%d%H%M%S)
}

# Rollout management.
alias kgrs='k get rs'
alias krh='k rollout history'
alias kru='k rollout undo'

# Statefulset management.
alias kgss='k get statefulset'
alias kgssw='kgss --watch'
alias kgsswide='kgss -o wide'
alias kess='k edit statefulset'
alias kdss='k describe statefulset'
alias kdelss='k delete statefulset'
alias ksss='k scale statefulset'
alias krsss='k rollout status statefulset'

# Port forwarding
alias kpf="k port-forward"

# Tools for accessing all information
alias kga='k get all'
alias kgaa='k get all --all-namespaces'

# Logs
alias kl='k logs'
alias klf='k logs -f'

# File copy
alias kcp='k cp'

# Node Management
alias kgno='k get nodes'
alias keno='k edit node'
alias kdno='k describe node'
alias kdelno='k delete node'

# PVC management.
alias kgpvc='k get pvc'
alias kgpvcw='kgpvc --watch'
alias kepvc='k edit pvc'
alias kdpvc='k describe pvc'
alias kdelpvc='k delete pvc'

