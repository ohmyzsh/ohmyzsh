# to avoid slow shells, we do it manually
function kubectl() {
    if ! type __start_kubectl >/dev/null 2>&1; then
        source <(command kubectl completion zsh)
    fi

    command kubectl "$@"
}

function kube-ctx-show() {
 echo "`kubectl ctx -c` • `kubectl ns -c`"
}

alias show-kube-ctx="kube-ctx-show"
alias kc-current-ctx="kube-ctx-show"

function kube-list-local-contexts() {
  grep '^- name: ' ~/.kube/config | awk '{print $3}'
}

alias kc-list-local-contexts="kube-list-local-contexts"

alias kc-list-prod-contexts="kube-list-prod-contexts"

alias kc="kubectl"
alias k="kubectl"
alias mk="minikube"
alias kube-list-contexts="kubectl config get-contexts"

alias kc-site="kubectl-site"
