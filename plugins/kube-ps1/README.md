# Kubernetes prompt for zsh

A Kubernetes zsh prompt that displays the current cluster cluster
and the namespace.

Inspired by several tools used to simplify usage of kubectl

NOTE: If you are not using zsh, check out [kube-ps1](https://github.com/jonmosco/kube-ps1)
designed for bash as well as zsh.

## Requirements

The default prompt assumes you have the kubectl command line utility installed.  It
can be obtained here:

[Install and Set up kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

If using this with OpenShift, the oc tool needs installed.  It can be obtained from here:

[OC Client Tools](https://www.openshift.org/download.html)

## Helper utilities

There are several great tools that make using kubectl very enjoyable.

[kubectx and kubenx](https://github.com/ahmetb/kubectx) are great for
fast switching between clusters and namespaces.

## Prompt Structure

The prompt layout is:

```
(<symbol>|<cluster>:<namespace>)
```

## Enabling

In order to use kube-ps1 with Oh My Zsh, you'll need to enable them in the
.zshrc file. You'll find the zshrc file in your $HOME directory. Open it with
your favorite text editor and you'll see a spot to list all the plugins you
want to load.

```shell
vim $HOME/.zshrc
```

Add kube-ps1 to the list of enabled plugins and enable it on the prompt:

```shell
plugins=(
  git
  kube-ps1
)

PROMPT=$PROMPT'$(kube_ps1) '
```

Note: the `PROMPT` example above was tested with the theme `robbyrussell`

## Enabling / Disabling on the current shell

Sometimes the kubernetes information can be anoying, you can easily 
switch it on and off with the following commands:

```shell
kubeon
```

```shell
kubeoff
```

## Colors

Blue was used as the prefix to match the Kubernetes color as closely as
possible. Red was chosen as the cluster name to stand out, and cyan
for the namespace. Check the customization section for changing them.

## Customization

The default settings can be overridden in ~/.zshrc

| Variable | Default | Meaning |
| :------- | :-----: | ------- |
| `KUBE_PS1_BINARY` | `kubectl` | Default Kubernetes binary |
| `KUBE_PS1_PREFIX` | `(` | Prompt opening character  |
| `KUBE_PS1_SYMBOL_ENABLE` | `true ` | Display the prompt Symbol. If set to `false`, this will also disable `KUBE_PS1_SEPARATOR` |
| `KUBE_PS1_SYMBOL_DEFAULT` | `⎈ ` | Default prompt symbol. Unicode `\u2388` |
| `KUBE_PS1_SYMBOL_USE_IMG` | `false` | ☸️  ,  Unicode `\u2638` as the prompt symbol |
| `KUBE_PS1_NS_ENABLE` | `true` | Display the namespace. If set to `false`, this will also disable `KUBE_PS1_DIVIDER` |
| `KUBE_PS1_SEPERATOR` | `\|` | Separator between symbol and cluster name |
| `KUBE_PS1_DIVIDER` | `:` | Separator between cluster and namespace |
| `KUBE_PS1_SUFFIX` | `)` | Prompt closing character |
| `KUBE_PS1_COLOR_SYMBOL` | `"%F{blue}"` | Custom color for the symbol |
| `KUBE_PS1_COLOR_CONTEXT` | `"%F{red}"` | Custom color for the context |
| `KUBE_PS1_COLOR_NS` | `"%F{cyan}"` | Custom color for the namespace |
| `KUBE_PS1_ENABLED` | `true` | Set to false to start disabled on any new shell, `kubeon`/`kubeoff` will flip this value on the current shell |

## Contributors

- Jared Yanovich
- Pedro Moranga