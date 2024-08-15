# Helm plugin

This plugin adds completion and aliases for [Helm](https://helm.sh/), the Kubernetes package manager.

To use it, add `helm` to the plugins array in your zshrc file:

```zsh
plugins=(... helm)
```

## Aliases

| Alias |  Full command                     |
| ----- | ----------------------------------|
| h     | helm                              |
| hco   | helm completion                   |
| hct   | helm create                       |
| hde   | helm delete                       |
| hen   | helm env                          |
| hgm   | helm get manifest                 |
| hhp   | helm help                         |
| hid   | helm install --debug --dry-run    |
| hin   | helm install                      |
| hls   | helm list                         |
| hlt   | helm lint                         |
| hpl   | helm pull                         |
| hps   | helm push                         |
| hra   | helm repo add                     |
| hrb   | helm rollback                     |
| hrr   | helm repo remove                  |
| hru   | helm repo update                  |
| hse   | helm search                       |
| hsh   | helm show                         |
| hss   | helm satuts                       |
| hst   | helm history                      |
| hte   | helm template                     |
| htt   | helm test                         |
| hui   | helm upgrade -i                   |
| hun   | helm uninstall                    |
| hup   | helm upgrade                      |
| hvn   | helm version                      |
| hvy   | helm verify                       |