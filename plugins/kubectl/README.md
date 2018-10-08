# Kubectl plugin

This plugin adds completion for the [Kubernetes cluster manager](https://kubernetes.io/docs/reference/kubectl/kubectl/),
as well as some aliases for common kubectl commands.

To use it, add `kubectl` to the plugins array in your zshrc file:

```zsh
plugins=(... kubectl)
```

## Aliases

| Alias     | Command                                                        | Description                                                                       |
|-----------|----------------------------------------------------------------|-----------------------------------------------------------------------------------|
| k         | `kubectl`                                                      | The kubectl command                                                               |
| kaf       | `kubectl apply -f`                                             | Apply a YML file                                                                  |
| keti      | `kubectl exec -ti`                                             | Drop into an interactive terminal on a container                                  |
|           |                                                                | **Manage configuration quickly to switch contexts between local, dev ad staging** |
| kcuc      | `kubectl config use-context`                                   | Sets the current-context in a kubeconfig file                                     |
| kcsc      | `kubectl config set-context`                                   | Sets a context entry in kubeconfig.                                               |
| kcdc      | `kubectl config delete-context`                                | Delete the specified context from the kubeconfig                                  |
| kccc      | `kubectl config current-context`                               | Displays the current-context                                                      |
|           |                                                                | **General aliases**                                                               |
| kdel      | `kubectl delete`                                               | Delete resources by filenames, stdin, resources and names, or by resources and label selector. |
| kdelf     | `kubectl delete -f`                                            | Delete a pod using the type and name specified in -f arguement.                   |
|           |                                                                | **Pod management**                                                                |
| kgp       | `kubectl get pods`                                             | List all pods in ps output format.                                                |
| kgpw      | `kgp --watch`                                                  | After listing/getting the requested object, watch for changes                     |
| kgpwide   | `kgp -o wide`                                                  | Output in the plain-text format with any additional information. For pods, the node name is included |
| kep       | `kubectl edit pods`                                            | ^^                                                                                |
| kdp       | `kubectl describe pods`                                        | ^^                                                                                |
| kdelp     | `kubectl delete pods`                                          | ^^                                                                                |
| kgpl      | `function _kgpl(){ label=$1; shift; kgp -l $label $*; };_kgpl` | get pod by label: kgpl "app=myapp" -n myns                                        |
|           |                                                                | **Service nagement**                                                              |
| kgs       | `kubectl get svc`                                              |                                                                                   |
| kgsw      | `kgs --watch`                                                  | ^^                                                                                |
| kgswide   | `kgs -o wide`                                                  | ^^                                                                                |
| kes       | `kubectl edit svc`                                             | ^^                                                                                |
| kds       | `kubectl describe svc`                                         | ^^                                                                                |
| kdels     | `kubectl delete svc`                                           | ^^                                                                                |
|           |                                                                | **Ingress management**                                                            |
| kgi       | `kubectl get ingress`                                          |                                                                                   |
| kei       | `kubectl edit ingress`                                         | ^^                                                                                |
| kdi       | `kubectl describe ingress`                                     | ^^                                                                                |
| kdeli     | `kubectl delete ingress`                                       | ^^                                                                                |
|           |                                                                | **Namespace management**                                                          |
| kgns      | `kubectl get namespaces`                                       |                                                                                   |
| kens      | `kubectl edit namespace`                                       | ^^                                                                                |
| kdns      | `kubectl describe namespace`                                   | ^^                                                                                |
| kdelns    | `kubectl delete namespace`                                     | ^^                                                                                |
|           |                                                                | **ConfigMap management**                                                          |
| kgcm      | `kubectl get configmaps`                                       |                                                                                   |
| kecm      | `kubectl edit configmap`                                       | ^^                                                                                |
| kdcm      | `kubectl describe configmap`                                   | ^^                                                                                |
| kdelcm    | `kubectl delete configmap`                                     | ^^                                                                                |
|           |                                                                | **Secret management**                                                             |
| kgsec     | `kubectl get secret`                                           |                                                                                   |
| kdsec     | `kubectl describe secret`                                      | ^^                                                                                |
| kdelsec   | `kubectl delete secret`                                        | ^^                                                                                |
|           |                                                                | **Deployment management**                                                         |
| kgd       | `kubectl get deployment`                                       |                                                                                   |
| kgdw      | `kgd --watch`                                                  | ^^                                                                                |
| kgdwide   | `kgd -o wide`                                                  | ^^                                                                                |
| ked       | `kubectl edit deployment`                                      | ^^                                                                                |
| kdd       | `kubectl describe deployment`                                  | ^^                                                                                |
| kdeld     | `kubectl delete deployment`                                    | ^^                                                                                |
| ksd       | `kubectl scale deployment`                                     | ^^                                                                                |
| krsd      | `kubectl rollout status deployment`                            | ^^                                                                                |
|           |                                                                | **Rollout management**                                                            |
| kgrs      | `kubectl get rs`                                               |                                                                                   |
| krh       | `kubectl rollout history`                                      | ^^                                                                                |
| kru       | `kubectl rollout undo`                                         | ^^                                                                                |
|           |                                                                | **Port forwarding**                                                               |
| kpf       | `kubectl port-forward`                                         |                                                                                   |
|           |                                                                | **Tools for accessing all information**                                           |
| kga       | `kubectl get all`                                              |                                                                                   |
| kgaa      | `kubectl get all --all-namespaces`                             | ^^                                                                                |
|           |                                                                | **Logs**                                                                          |
| kl        | `kubectl logs`                                                 |                                                                                   |
| klf       | `kubectl logs -f`                                              | ^^                                                                                |
|           |                                                                | **File copy**                                                                     |
| kcp       | `kubectl cp`                                                   |                                                                                   |
|           |                                                                | **Node Management**                                                               |
| kgno      | `kubectl get nodes`                                            |                                                                                   |
| keno      | `kubectl edit node`                                            | ^^                                                                                |
| kdno      | `kubectl describe node`                                        | ^^                                                                                |
| kdelno    | `kubectl delete node`                                          | ^^ |                                                                                                                                                    


