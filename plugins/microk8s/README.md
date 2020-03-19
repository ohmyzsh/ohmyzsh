# MicroK8s plugin

This plugin provides completion and useful aliases for [MicroK8s](https://microk8s.io/).

To use it, add `microk8s` to the plugins array in your zshrc file.

```zsh
plugins=(... microk8s)
```

## Aliases

| Alias | Command          | Description                                                                                              |
|-------|------------------|----------------------------------------------------------------------------------------------------------|
| mco   | microk8s.config  | Shows the Kubernetes config file.                                                                        |
| mct   | microk8s.ctr     | Interact with containerd CLI.                                                                            |
| mdi   | microk8s.disable | Disables an addon.                                                                                       |
| me    | microk8s.enable  | Enables an addon.                                                                                        |
| mh    | microk8s.helm    | Interact with Helm CLI.                                                                                  |
| mis   | microk8s.istio   | Interact with Istio CLI.                                                                                 |
| mk    | microk8s.kubectl | Interact with Kubernetes CLI.                                                                            |
| msp   | microk8s.stop    | Stops all Kubernetes services.                                                                           |
| mst   | microk8s.start   | Starts MicroK8s after it is being stopped.                                                               |
| msts  | microk8s.status  | Provides an overview of the MicroK8s state (running / not running) as well as the set of enabled addons. |