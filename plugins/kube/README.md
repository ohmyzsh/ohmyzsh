# Kubectl context manager
Kubectl, the kubernetes client, needs context to work correctly. By default, it uses the file on `~/.kube/config`, which has an horrible design. With this plugin, the better approach is to not have a `~/.kube/config` file and `n` `~/.kube/something-config`. If you do so, you'll be able to manage multiple contexts easily.

This plugin is based on the [aws](https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins#aws) one. The functions that provides are `ksp` and `kgp`. The first one let's you choose between the contexts and the second one shows which one is being used.

See the `~/.kube` directory:

```bash
tree ~/.kube

/home/whatever/.kube
├── firstContext-config
└── secondContext-config
```
