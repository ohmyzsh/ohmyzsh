# Pulumi Oh My Zsh Plugin

This is an **Oh My Zsh plugin** for the **Pulumi CLI**, providing:
- 🚀 Short, intuitive aliases for common Pulumi commands
- 🎯 Auto-completion support for Pulumi

## 📦 Installation

To use this plugin, add `pulumi` to the plugins array in your `.zshrc` file:  

```zsh
plugins=(... pulumi)
```
Then run ```source ~/.zshrc```


---

## ⚡ Short Aliases

| Alias  | Command                  | Description                      |
|--------|--------------------------|----------------------------------|
| `p`    | `pulumi`                 | Shortcut for Pulumi CLI         |
| `pu`   | `pulumi up`              | Deploy infrastructure           |
| `pp`   | `pulumi preview`         | Show planned changes            |
| `pd`   | `pulumi destroy`         | Destroy all resources           |
| `pr`   | `pulumi refresh`         | Refresh state from cloud        |
| `ps`   | `pulumi stack`           | Show stack details              |
| `pss`  | `pulumi stack select`    | Switch stack                    |
| `psh`  | `pulumi stack history`   | Show stack history              |
| `psi`  | `pulumi stack init`      | Initialize a new stack          |
| `psl`  | `pulumi stack ls`        | List available stacks           |
| `pso`  | `pulumi stack output`    | Show stack outputs              |
| `plog` | `pulumi logs -f`         | Tail Pulumi logs in real-time   |
| `pcs`  | `pulumi config set`      | Set Pulumi configuration        |

---

## 🎯 Autocompletion
If `pulumi gen-completion zsh` is available, this plugin **automatically enables Pulumi auto-completion**.

---

## 🛠️ Contribution
Feel free to open an issue or PR for improvements! 🚀

