# chezmoi Plugin

## Introduction

This `chezmoi` plugin sets up completion for [chezmoi](https://chezmoi.io).

To use it, add `chezmoi` to the plugins array of your zshrc file:

```bash
plugins=(... chezmoi)
```

## Aliases

| Alias | Command            | Description                                                    |
|:------|:-------------------|:---------------------------------------------------------------|
| `cm`  | `chezmoi`          | Chezmoi main command                                           |
| `cma` | `chezmoi apply`    | Apply changes to the target file                               |
| `cmr` | `chezmoi re-apply` | Re-apply changes to the target file                            |
| `cmc` | `chezmoi cd`       | Launch a shell in the source directory                         |
| `cmd` | `chezmoi diff`     | Print the diff between the actual state and the target state   |
| `cme` | `chezmoi edit`     | Edit the source state of a target                              |
| `cmg` | `chezmoi git`      | Run git in the source directory                                |
| `cmi` | `chezmoi init`     | Initialize the source directory and optionally the config file |
| `cms` | `chezmoi status`   | Show the status of targets                                     |
| `cmu` | `chezmoi update`   | Pull and apply changes from the source repository              |
