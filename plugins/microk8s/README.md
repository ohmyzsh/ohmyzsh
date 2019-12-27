# MicroK8s plugin

This plugin provides completion and useful aliases for [MicroK8s](https://microk8s.io/).

To use it, add `microk8s` to the plugins array in your zshrc file.

```
plugins=(... microk8s)
```

## Aliases

| Alias         | Command                    | Description                                                                                              |
|---------------|----------------------------|----------------------------------------------------------------------------------------------------------|
| me `addon`    | microk8s.enable `addon`    | Enables an addon.                                                                                        |
| mdi `addon`   | microk8s.disable `addon`   | Disables an addon.                                                                                       |
| mk `command`  | microk8s.kubectl `command` | Interact with Kubernetes CLI.                                                                            |
| mh `command`  | microk8s.helm `command`    | Interact with Helm CLI.                                                                                  |
| mco           | microk8s.config            | Shows the kubernetes config file.                                                                        |
| mct `command` | microk8s.ctr `command`     | Interact with containerd CLI.                                                                            |
| mis `command` | microk8s.istio `command`   | Interact with Istio CLI.                                                                                 |
| mst           | microk8s.start             | Starts MicroK8s after it is being stopped.                                                               |
| msts          | microk8s.status            | Provides an overview of the MicroK8s state (running / not running) as well as the set of enabled addons. |
| msp           | microk8s.stop              | Stops all kubernetes services.                                                                           |