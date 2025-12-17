# Pulumi

This is an **Oh My Zsh plugin** for the [**Pulumi CLI**](https://www.pulumi.com/docs/iac/cli/),
an Infrastructure as Code (IaC) tool for building, deploying and managing cloud infrastucture.

This plugin provides:

- 🚀 Short, intuitive aliases for common Pulumi commands
- 🎯 Auto-completion support for Pulumi

To use it, add `pulumi` to the plugins array in your `.zshrc` file:  

```zsh
plugins=(... pulumi)
```

## ⚡ Aliases

| Alias    | Command                | Description                   |
| -------- | ---------------------- | ----------------------------- |
| `pul`    | `pulumi`               | Shortcut for Pulumi CLI       |
| `pulcs`  | `pulumi config set`    | Set Pulumi configuration      |
| `puld`   | `pulumi destroy`       | Destroy all resources         |
| `pullog` | `pulumi logs -f`       | Tail Pulumi logs in real-time |
| `pulp`   | `pulumi preview`       | Show planned changes          |
| `pulr`   | `pulumi refresh`       | Refresh state from cloud      |
| `puls`   | `pulumi stack`         | Show stack details            |
| `pulsh`  | `pulumi stack history` | Show stack history            |
| `pulsi`  | `pulumi stack init`    | Initialize a new stack        |
| `pulsl`  | `pulumi stack ls`      | List available stacks         |
| `pulso`  | `pulumi stack output`  | Show stack outputs            |
| `pulss`  | `pulumi stack select`  | Switch stack                  |
| `pulu`   | `pulumi up`            | Deploy infrastructure         |

## 🎯 Autocompletion

If `pulumi gen-completion zsh` is available, this plugin **automatically loads Pulumi auto-completion**.

## 🛠️ Contribution

Feel free to open an issue or PR for improvements! 🚀
