# Kubectl plugin

This plugin adds completion for the [Kubernetes cluster manager](https://kubernetes.io/docs/reference/kubectl/kubectl/),
as well as some aliases for common kubectl commands.

To use it, add `kubectl` to the plugins array in your zshrc file:

```zsh
plugins=(... kubectl)
```

## Aliases

| Alias   | Command                                   | Description                                                                                       |
|:--------|:------------------------------------------|:--------------------------------------------------------------------------------------------------|
| k       | `kubectl`                                 | The kubectl command                                                                               |
| kca     | `kubectl --all-namespaces`                | The kubectl command targeting all namespaces                                                      |
| kaf     | `kubectl apply -f`                        | Apply a YML file                                                                                  |
| keti    | `kubectl exec -ti`                        | Drop into an interactive terminal on a container                                                  |
|         |                                           | **Manage configuration quickly to switch contexts between local, dev and staging**                |
| kcuc    | `kubectl config use-context`              | Set the current-context in a kubeconfig file                                                      |
| kcsc    | `kubectl config set-context`              | Set a context entry in kubeconfig                                                                 |
| kcdc    | `kubectl config delete-context`           | Delete the specified context from the kubeconfig                                                  |
| kccc    | `kubectl config current-context`          | Display the current-context                                                                       |
| kcgc    | `kubectl config get-contexts`             | List of contexts available                                                                        |
|         |                                           | **General aliases**                                                                               |
| kdel    | `kubectl delete`                          | Delete resources by filenames, stdin, resources and names, or by resources and label selector     |
| kdelf   | `kubectl delete -f`                       | Delete a pod using the type and name specified in -f argument                                     |
|         |                                           | **Pod management**                                                                                |
| kgp     | `kubectl get pods`                        | List all pods in ps output format                                                                 |
| kgpw    | `kgp --watch`                             | After listing/getting the requested object, watch for changes                                     |
| kgpwide | `kgp -o wide`                             | Output in plain-text format with any additional information. For pods, the node name is included  |
| kep     | `kubectl edit pods`                       | Edit pods from the default editor                                                                 |
| kdp     | `kubectl describe pods`                   | Describe all pods                                                                                 |
| kdelp   | `kubectl delete pods`                     | Delete all pods matching passed arguments                                                         |
| kgpl    | `kgp -l`                                  | Get pods by label. Example: `kgpl "app=myapp" -n myns`                                            |
| kgpn    | `kgp -n`                                  | Get pods by namespace. Example: `kgpn kube-system`                                                |
|         |                                           | **Service management**                                                                            |
| kgs     | `kubectl get svc`                         | List all services in ps output format                                                             |
| kgsw    | `kgs --watch`                             | After listing all services, watch for changes                                                     |
| kgswide | `kgs -o wide`                             | After listing all services, output in plain-text format with any additional information           |
| kes     | `kubectl edit svc`                        | Edit services(svc) from the default editor                                                        |
| kds     | `kubectl describe svc`                    | Describe all services in detail                                                                   |
| kdels   | `kubectl delete svc`                      | Delete all services matching passed argument                                                      |
|         |                                           | **Ingress management**                                                                            |
| kgi     | `kubectl get ingress`                     | List ingress resources in ps output format                                                        |
| kei     | `kubectl edit ingress`                    | Edit ingress resource from the default editor                                                     |
| kdi     | `kubectl describe ingress`                | Describe ingress resource in detail                                                               |
| kdeli   | `kubectl delete ingress`                  | Delete ingress resources matching passed argument                                                 |
|         |                                           | **Namespace management**                                                                          |
| kgns    | `kubectl get namespaces`                  | List the current namespaces in a cluster                                                          |
| kcns    | `kubectl create namespace`                | Create a namespace in the cluster                                                                 |
| kens    | `kubectl edit namespace`                  | Edit namespace resource from the default editor                                                   |
| kdns    | `kubectl describe namespace`              | Describe namespace resource in detail                                                             |
| kdelns  | `kubectl delete namespace`                | Delete the namespace. WARNING! This deletes everything in the namespace                           |
| kcn     | `kubectl config set-context ...`          | Change current namespace                                                                          |
|         |                                           | **ConfigMap management**                                                                          |
| kgcm    | `kubectl get configmaps`                  | List the configmaps in ps output format                                                           |
| kecm    | `kubectl edit configmap`                  | Edit configmap resource from the default editor                                                   |
| kdcm    | `kubectl describe configmap`              | Describe configmap resource in detail                                                             |
| kdelcm  | `kubectl delete configmap`                | Delete the configmap                                                                              |
|         |                                           | **Secret management**                                                                             |
| kgsec   | `kubectl get secret`                      | Get secret for decoding                                                                           |
| kdsec   | `kubectl describe secret`                 | Describe secret resource in detail                                                                |
| kdelsec | `kubectl delete secret`                   | Delete the secret                                                                                 |
|         |                                           | **Deployment management**                                                                         |
| kgd     | `kubectl get deployment`                  | Get the deployment                                                                                |
| kgdw    | `kgd --watch`                             | After getting the deployment, watch for changes                                                   |
| kgdwide | `kgd -o wide`                             | After getting the deployment, output in plain-text format with any additional information         |
| ked     | `kubectl edit deployment`                 | Edit deployment resource from the default editor                                                  |
| kdd     | `kubectl describe deployment`             | Describe deployment resource in detail                                                            |
| kdeld   | `kubectl delete deployment`               | Delete the deployment                                                                             |
| ksd     | `kubectl scale deployment`                | Scale a deployment                                                                                |
| ksd0    | `kubectl scale deployment --replicas=0`   | Scale a deployment to 0 replicas                                                                  |
| ksd1    | `kubectl scale deployment --replicas=1`   | Scale a deployment to 1 replica                                                                   |
| ksd2    | `kubectl scale deployment --replicas=2`   | Scale a deployment to 2 replicas                                                                  |
| ksd3    | `kubectl scale deployment --replicas=3`   | Scale a deployment to 3 replicas                                                                  |
| ksd4    | `kubectl scale deployment --replicas=4`   | Scale a deployment to 4 replicas                                                                  |
| ksd5    | `kubectl scale deployment --replicas=5`   | Scale a deployment to 5 replicas                                                                  |
| ksd6    | `kubectl scale deployment --replicas=6`   | Scale a deployment to 6 replicas                                                                  |
| ksd7    | `kubectl scale deployment --replicas=7`   | Scale a deployment to 7 replicas                                                                  |
| ksd8    | `kubectl scale deployment --replicas=8`   | Scale a deployment to 8 replicas                                                                  |
| ksd9    | `kubectl scale deployment --replicas=9`   | Scale a deployment to 9 replicas                                                                  |
| ksd10   | `kubectl scale deployment --replicas=10`  | Scale a deployment to 10 replicas                                                                 |
| krsd    | `kubectl rollout status deployment`       | Check the rollout status of a deployment                                                          |
| kres    | `kubectl set env $@ REFRESHED_AT=...`     | Recreate all pods in deployment with zero-downtime                                                |
|         |                                           | **Rollout management**                                                                            |
| kgrs    | `kubectl get rs`                          | To see the ReplicaSet `rs` created by the deployment                                              |
| krh     | `kubectl rollout history`                 | Check the revisions of this deployment                                                            |
| kru     | `kubectl rollout undo`                    | Rollback to the previous revision                                                                 |
|         |                                           | **Port forwarding**                                                                               |
| kpf     | `kubectl port-forward`                    | Forward one or more local ports to a pod                                                          |
|         |                                           | **Tools for accessing all information**                                                           |
| kga     | `kubectl get all`                         | List all resources in ps format                                                                   |
| kgaa    | `kubectl get all --all-namespaces`        | List the requested object(s) across all namespaces                                                |
|         |                                           | **Logs**                                                                                          |
| kl      | `kubectl logs`                            | Print the logs for a container or resource                                                        |
| klf     | `kubectl logs -f`                         | Stream the logs for a container or resource (follow)                                              |
|         |                                           | **File copy**                                                                                     |
| kcp     | `kubectl cp`                              | Copy files and directories to and from containers                                                 |
|         |                                           | **Node management**                                                                               |
| kgno    | `kubectl get nodes`                       | List the nodes in ps output format                                                                |
| keno    | `kubectl edit node`                       | Edit nodes resource from the default editor                                                       |
| kdno    | `kubectl describe node`                   | Describe node resource in detail                                                                  |
| kdelno  | `kubectl delete node`                     | Delete the node                                                                                   |
|         |                                           | **Persistent Volume Claim management**                                                            |
| kgpvc   | `kubectl get pvc`                         | List all PVCs                                                                                     |
| kgpvcw  | `kgpvc --watch`                           | After listing/getting the requested object, watch for changes                                     |
| kepvc   | `kubectl edit pvc`                        | Edit pvcs from the default editor                                                                 |
| kdpvc   | `kubectl describe pvc`                    | Describe all pvcs                                                                                 |
| kdelpvc | `kubectl delete pvc`                      | Delete all pvcs matching passed arguments                                                         |
|         |                                           | **StatefulSets management**                                                                       |
| kgss    | `kubectl get statefulset`                 | List the statefulsets in ps format                                                                |
| kgssw   | `kgss --watch`                            | After getting the list of statefulsets, watch for changes                                         |
| kgsswide| `kgss -o wide`                            | After getting the statefulsets, output in plain-text format with any additional information       |
| kess    | `kubectl edit statefulset`                | Edit statefulset resource from the default editor                                                 |
| kdss    | `kubectl describe statefulset`            | Describe statefulset resource in detail                                                           |
| kdelss  | `kubectl delete statefulset`              | Delete the statefulset                                                                            |
| ksss    | `kubectl scale statefulset`               | Scale a statefulset                                                                               |
| ksss0   | `kubectl scale statefulset --replicas=0`  | Scale a statefulset to 0 replicas                                                                 |
| ksss1   | `kubectl scale statefulset --replicas=1`  | Scale a statefulset to 1 replica                                                                  |
| ksss2   | `kubectl scale statefulset --replicas=2`  | Scale a statefulset to 2 replicas                                                                 |
| ksss3   | `kubectl scale statefulset --replicas=3`  | Scale a statefulset to 3 replicas                                                                 |
| ksss4   | `kubectl scale statefulset --replicas=4`  | Scale a statefulset to 4 replicas                                                                 |
| ksss5   | `kubectl scale statefulset --replicas=5`  | Scale a statefulset to 5 replicas                                                                 |
| ksss6   | `kubectl scale statefulset --replicas=6`  | Scale a statefulset to 6 replicas                                                                 |
| ksss7   | `kubectl scale statefulset --replicas=7`  | Scale a statefulset to 7 replicas                                                                 |
| ksss8   | `kubectl scale statefulset --replicas=8`  | Scale a statefulset to 8 replicas                                                                 |
| ksss9   | `kubectl scale statefulset --replicas=9`  | Scale a statefulset to 9 replicas                                                                 |
| ksss10  | `kubectl scale statefulset --replicas=10` | Scale a statefulset to 10 replicas                                                                |
| krsss   | `kubectl rollout status statefulset`      | Check the rollout status of a deployment                                                          |
|         |                                           | **Service Accounts management**                                                                   |
| kgsa    | `kubectl get sa`                          | List all service accounts                                                                         |
| kdsa    | `kubectl describe sa`                     | Describe a service account in details                                                             |
| kdelsa  | `kubectl delete sa`                       | Delete the service account                                                                        |
|         |                                           | **DaemonSet management**                                                                          |
| kgds    | `kubectl get daemonset`                   | List all DaemonSets in ps output format                                                           |
| kgdsw   | `kgds --watch`                            | After listing all DaemonSets, watch for changes                                                   |
| keds    | `kubectl edit daemonset`                  | Edit DaemonSets from the default editor                                                           |
| kdds    | `kubectl describe daemonset`              | Describe all DaemonSets in detail                                                                 |
| kdelds  | `kubectl delete daemonset`                | Delete all DaemonSets matching passed argument                                                    |
|         |                                           | **CronJob management**                                                                            |
| kgcj    | `kubectl get cronjob`                     | List all CronJobs in ps output format                                                             |
| kecj    | `kubectl edit cronjob`                    | Edit CronJob from the default editor                                                              |
| kdcj    | `kubectl describe cronjob`                | Describe a CronJob in details                                                                     |
| kdelcj  | `kubectl delete cronjob`                  | Delete the CronJob                                                                                |
|         |                                           | **Job management**                                                                                |
| kgj     | `kubectl get job`                         | List all Jobs in ps output format                                                                 |
| kej     | `kubectl edit job`                        | Edit Job from the default editor                                                                  |
| kdj     | `kubectl describe job`                    | Describe a Job in details                                                                         |
| kdelj   | `kubectl delete job`                      | Delete the Job                                                                                    |
|         |                                           | **top - resource utilization**                                                                    |
| ktno    | `kubectl top node`                        | Get resource utilization by node                                                                  |
| ktnoc   | `kubectl top node --sort-by="cpu"`        | Get resource utilization by node, sorted by CPU                                                   |
| ktnom   | `kubectl top node --sort-by="memory"   `  | Get resource utilization by node, sorted by memory                                                |
| ktp     | `kubectl top pod`                         | Get resource utilization by pod                                                                   |
| ktpc    | `kubectl top pod --sort-by="cpu"`         | Get resource utilization by pod, sorted by CPU                                                    |
| ktpm    | `kubectl top pod --sort-by="memory"`      | Get resource utilization by pod, sorted by memory                                                 |



## Wrappers

This plugin provides 3 wrappers to colorize kubectl output in JSON and YAML using various tools (which must be installed):

- `kj`: JSON, colorized with [`jq`](https://stedolan.github.io/jq/).
- `kjx`: JSON, colorized with [`fx`](https://github.com/antonmedv/fx).
- `ky`: YAML, colorized with [`yh`](https://github.com/andreazorzetto/yh).
