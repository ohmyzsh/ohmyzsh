# chezmoi Plugin

## Introduction

This `chezmoi` plugin provides completion and [aliases](#aliases) for [chezmoi](https://chezmoi.io).

To use it, add `chezmoi` to the plugins array of your zshrc file:

```zsh
plugins=(... chezmoi)
```

## Aliases

| Alias  | Command                | Description                                            |
| :----- | :--------------------- | :----------------------------------------------------- |
| `cm`   | `chezmoi`              | The base chezmoi command                               |
| `cma`  | `chezmoi add`          | Add a file to the source state                         |
| `cmap` | `chezmoi apply`        | Update the destination to match the target state       |
| `cmcd` | `chezmoi cd`           | Launch a shell in the source directory                 |
| `cmd`  | `chezmoi diff`         | Print the diff between target state and destination    |
| `cme`  | `chezmoi edit`         | Edit the source state of a target                      |
| `cmg`  | `chezmoi git`          | Run git in the source directory                        |
| `cmi`  | `chezmoi init`         | Set up the source directory                            |
| `cmia` | `chezmoi init --apply` | Set up the source directory and apply in one step      |
| `cmm`  | `chezmoi merge`        | Three-way merge for a file                             |
| `cmma` | `chezmoi merge-all`    | Three-way merge for all modified files                 |
| `cmra` | `chezmoi re-add`       | Re-add modified files                                  |
| `cmst` | `chezmoi status`       | Show the status of targets                             |
| `cmu`  | `chezmoi update`       | Pull and apply changes from the remote                 |
