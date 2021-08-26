alias ts-resolve-host="tsunami variables resolve --unit-type host "

function ts-variables-show() {
  tsunami variables show $1 $2
}
function ts-variables-show-version() {
  tsunami variables history $1 $2
}

alias tsunami-resolve-host="ts-resolve-host"
alias tsunami-variables-show="ts-variables-show"
alias tsunami-variables-show-version="ts-variables-show-version"

# to avoid slow shells, we do it manually
function kubectl() {
    if ! type __start_kubectl >/dev/null 2>&1; then
        source <(command kubectl completion zsh)
    fi

    command kubectl "$@"
}
function kube-ctx-show() {
 echo "`kube ctx -c` • `kc ns -c`"
}

alias show-kube-ctx="kube-ctx-show"
alias kc-current-ctx="kube-ctx-show"

function kube-list-local-contexts() {
  grep '^- name: ' ~/.kube/config | awk '{print $3}'
}

alias kc-list-local-contexts="kube-list-local-contexts"

function kube-list-prod-contexts() {
  gcloud container clusters list --project=gke-xpn-1 --filter="resourceLabels[env]=production" --format="value(name)"
}

alias kc-list-prod-contexts="kube-list-prod-contexts"

alias kc="kubectl"
alias mk="minikube"
alias kube-list-contexts="kubectl config get-contexts"
