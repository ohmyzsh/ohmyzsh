# Kind plugin

This plugin adds completion for the [Kind](https://kind.sigs.k8s.io/) tool, as well
as a few aliases for easier use.

To use it, add `kind` to the plugins array in your zshrc file:

```zsh
plugins=(... kind)
```

## Aliases

| Alias   | Command                      |
| ------- | ---------------------------- |
| `kicc`  | `kind create cluster`        |
| `kiccn` | `kind create cluster --name` |
| `kigc`  | `kind get clusters`          |
| `kidc`  | `kind delete cluster`        |
| `kidcn` | `kind delete cluster --name` |
| `kidca` | `kind delete clusters -A`    |
| `kigk`  | `kind get kubeconfig`        |
