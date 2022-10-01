# k3d plugin

This plugin adds completion for [k3d](https://k3d.io/), a lightweight wrapper
around [k3s](https://github.com/k3s-io/k3s) to make it easy to create single- or
multi-node clusters in docker. It can be used for local development on Kubernetes

To use it, add `k3d` to the plugins array in your zshrc file:

```zsh
plugins=(... k3d)
```
