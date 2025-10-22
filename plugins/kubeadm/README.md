# kubeadm plugin

This plugin adds completion for the [kubernetes cluster creator](https://kubernetes.io/docs/reference/setup-tools/kubeadm/).
Kubeadm is a tool built to provide kubeadm init and kubeadm join as best-practice "fast paths" for creating Kubernetes clusters.

To use it, add `kubeadm` to the plugins array in your zshrc file:

```zsh
plugins=(... kubeadm)
```
