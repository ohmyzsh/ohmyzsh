# Git-Flow plugin

This plugin adds completion and aliases for the [`git-flow` command](https://github.com/nvie/gitflow).

To use it, add `git-flow` to the plugins array in your zshrc file:

```zsh
plugins=(... git-flow)
```

## Aliases

| Alias     | Command                                   | Description                                    |
| --------- | ----------------------------------------- | ---------------------------------------------- |
| `gcd`     | `git checkout develop`                    | Check out develop branch                       |
| `gch`     | `git checkout hotfix`                     | Check out hotfix branch                        |
| `gcr`     | `git checkout release`                    | Check out release branch                       |
| `gfl`     | `git flow`                                | Git-Flow command                               |
| `gflf`    | `git flow feature`                        | List existing feature branches                 |
| `gflff`   | `git flow feature finish`                 | Finish feature: `gflff <name>`                 |
| `gflffc`  | `gflff ${$(git_current_branch)#feature/}` | Finish current feature                         |
| `gflfp`   | `git flow feature publish`                | Publish feature: `gflfp <name>`                |
| `gflfpc`  | `gflfp ${$(git_current_branch)#feature/}` | Publish current feature                        |
| `gflfpll` | `git flow feature pull`                   | Pull remote feature: `gflfpll <remote> <name>` |
| `gflfs`   | `git flow feature start`                  | Start a new feature: `gflfs <name>`            |
| `gflh`    | `git flow hotfix`                         | List existing hotfix branches                  |
| `gflhf`   | `git flow hotfix finish`                  | Finish hotfix: `gflhf <version>`               |
| `gflhfc`  | `gflhf ${$(git_current_branch)#hotfix/}`  | Finish current hotfix                          |
| `gflhp`   | `git flow hotfix publish`                 | Publish hostfix: `gflhp <version>`             |
| `gflhpc`  | `gflhp ${$(git_current_branch)#hotfix/}`  | Finish current hotfix                          |
| `gflhs`   | `git flow hotfix start`                   | Start a new hotfix: `gflhs <version>`          |
| `gfli`    | `git flow init`                           | Initialize git-flow repository                 |
| `gflr`    | `git flow release`                        | List existing release branches                 |
| `gflrf`   | `git flow release finish`                 | Finish release: `gflrf <version>`              |
| `gflrfc`  | `gflrf ${$(git_current_branch)#release/}` | Finish current release                         |
| `gflrp`   | `git flow release publish`                | Publish release: `gflrp <version>`             |
| `gflrpc`  | `gflrp ${$(git_current_branch)#release/}` | Publish current release                        |
| `gflrs`   | `git flow release start`                  | Start a new release: `gflrs <version>`         |

[More information about `git-flow` commands](https://github.com/nvie/gitflow/wiki/Command-Line-Arguments).
