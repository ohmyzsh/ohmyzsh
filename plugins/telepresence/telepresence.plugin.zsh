_telepresence() {
    kube_get_service_list() {
        kubectl get services -o name | sed  "s/service\///g"
    }

    kube_get_context_list() {
        kubectl config get-contexts -o name
    }

    kube_get_namespace_list() {
        kubectl get namespaces -o name | sed "s/namespace\///g"
    }

    kube_get_pod_list() {
        kubectl get pods -o name | sed "s/pod\///g"
    }
    args+=(
    "--version[show program's version number and exit]"
    "--logfile[The path to write logs to. '-' means stdout, default is './telepresence.log'.]"
    "--verbose[Enables verbose logging for troubleshooting.]"
    "(-m --method)"{-m,--method}'[Proxy method]:method:(inject-tcp vpn-tcp container)'
    "--new-deployment[Create a new Deployment in Kubernetes where the datawire/telepresence-k8s image will run.]"
    "(-s --swap-deployment)"{-s,--swap-deployment}"[Swap out an existing deployment with the Telepresence proxy, swap back on exit.]:swap-deployment:($(kube_get_service_list))"
    "(-d --deployment)"{-d,--deployment}"[The name of an existing Kubernetes Deployment where the datawire/telepresence-k8s image is already running.]:deployment:($(kube_get_service_list))"
    "--context[The Kubernetes context to use. Defaults to current kubectl context.]:context:($(kube_get_context_list))"
    "--namespace[The Kubernetes namespace to use. Defaults to kubectl's default for the current context, which is usually 'default'.]:namespace:($(kube_get_namespace_list))"
    "--serviceaccount[The Kubernetes service account to use. Sets the value for a new deployment or overrides the value for a swapped deployment.]"
    "--expose[Port number that will be exposed to Kubernetes in the Deployment.]"
    "--to-pod[Access localhost:PORT on other containers in the swapped deployment's pod from your host or local container.]:to-pod:($(kube_get_pod_list))"
    "--from-pod[Allow access to localhost:PORT on your host or local container from other containers in the swapped deployment's pod.]:from-pod:($(kube_get_pod_list))"
    "--also-proxy[If you are using --method=vpn-tcp, use this to add additional remote IPs, IP ranges, or hostnames to proxy.]"
    "--local-cluster[If you are using --method=vpn-tcp with a local cluster (one that is running on the same computer as Telepresence) and you experience DNS loops or loss of Internet connectivity while Telepresence is running, use this flag to enable an internal workaround that may help.]"
    "--docker-mount[The absolute path for the root directory where volumes will be mounted, $TELEPRESENCE_ROOT. Requires --method container.]"
    "--mount[The absolute path for the root directory where volumes will be mounted]"
    "--env-json[Also emit the remote environment to a file as a JSON blob.]"
    "--env-file[Also emit the remote environment to an env file in Docker Compose format.]"
    "--run-shell[Run a local shell that will be proxied to/from Kubernetes.]"
    "--run[Run the specified command arguments]"
    "--docker-run[Run a Docker container, by passing the arguments to 'docker run']"
    )
    _arguments -w -s -S $args[@] && ret=0
    return ret
}

compdef _telepresence telepresence
