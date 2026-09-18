# chezmoi Plugin

## Introduction

This `chezmoi` plugin sets up completion for [chezmoi](https://chezmoi.io).

To use it, add `chezmoi` to the plugins array of your zshrc file:

```bash
plugins=(... chezmoi)
```

## Aliases

| Alias | Command          | Description                                                    |
|:------|:-----------------|:---------------------------------------------------------------|
| `cz`  | `chezmoi`        | Chezmoi main command                                           |
| `cza` | `chezmoi apply`  | Apply changes in the target state                              |
| `czc` | `chezmoi cd`     | Launch a shell in the source directory                         |
| `czd` | `chezmoi diff`   | Print the diff between the actual state and the target state   |
| `cze` | `chezmoi edit`   | Edit the source state of a target                              |
| `czg` | `chezmoi git`    | Run git in the source directory                                |
| `czi` | `chezmoi init`   | Initialize the source directory and optionally the config file |
| `czs` | `chezmoi status` | Show the status of targets                                     |
| `czu` | `chezmoi update` | Pull and apply changes from the source repository              |
