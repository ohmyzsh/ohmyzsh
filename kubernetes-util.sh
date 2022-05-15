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
 echo "`kubectl ctx -c` • `kubectl ns -c`"
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
alias k="kubectl"
alias mk="minikube"
alias kube-list-contexts="kubectl config get-contexts"

alias kc-site="kubectl-site"

# Record all pods belonging to a given namespace across all clusters that are
# configured
function list-all-pods-multi-cluster () {
  mv all-pods.txt all-pods.txt~ 2>&1 > /dev/null

  KC_NS=$1
  echo
  echo "Finding all pods for namespace $KC_NS across all configured clusters hello-k8s-replicaset.yaml# hello-k8s-replicaset.yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: hello-k8s-<username>
  namespace: tech-learning
spec:
  replicas: 3
  selector:
    matchLabels:
      app: hello-k8s-<username>
  template:
    metadata:
      annotations:
        podpreset.admission.spotify.com/exclude: 'ffwd-java-shim-container, spotify-envs'
      labels:
        app: hello-k8s-<username>
    spec:
      containers:
      - name: hello-k8s
        image: gcr.io/tech-learning-2321/hello-k8s:0.0.1
        env:
        - name: USER_OVERRIDE
          value: "<username>"
        ports:
        - name: http
          containerPort: 8080
        resources:
          requests:
            cpu: 200m
            memory: 1G
          limits:
            cpu: 800m
            memory: 4Gand dumping them into ./all-pods.txt..."
  echo

  for CLUSTER in `kubectl ctx`; do
    case $CLUSTER in
    kind )
        echo "Skipping ${CLUSTER}."
         continue
         ;;
    docker )
        echo "Skipping ${CLUSTER}."
         continue
         ;;
    minikube )
        echo "Skipping ${CLUSTER}."
         continue
         ;;
    * )
         ;;
    esac

    echo "Processing cluster $CLUSTER..."

    kubectl ctx $CLUSTER
    kubectl ns $KC_NS
    kubectl get pods -o wide >> all-pods.txt
  done
}
