# Git-Flow plugin

This plugin adds completion and aliases for the `git-flow` command. More information
at https://github.com/nvie/gitflow.

Enable git-flow plugin in your zshrc file:
```
plugins=(... git-flow)
```

## Aliases

More information about `git-flow` commands:
https://github.com/nvie/gitflow/wiki/Command-Line-Arguments

| Alias   | Command                    | Description                            |
|---------|----------------------------|----------------------------------------|
| `gfl`   | `git flow`                 | Git-Flow command                       |
| `gfli`  | `git flow init`            | Initialize git-flow repository         |
| `gcd`   | `git checkout develop`     | Check out develop branch               |
| `gch`   | `git checkout hotfix`      | Check out hotfix branch                |
| `gcr`   | `git checkout release`     | Check out release branch               |
| `gflf`  | `git flow feature`         | List existing feature branches         |
| `gflh`  | `git flow hotfix`          | List existing hotfix branches          |
| `gflr`  | `git flow release`         | List existing release branches         |
| `gflfs` | `git flow feature start`   | Start a new feature: `gflfs <name>`    |
| `gflhs` | `git flow hotfix start`    | Start a new hotfix: `gflhs <version>`  |
| `gflrs` | `git flow release start`   | Start a new release: `gflrs <version>` |
| `gflff` | `git flow feature finish`  | Finish feature: `gflff <name>`         |
| `gflfp` | `git flow feature publish` | Publish feature: `gflfp <name>`        |
| `gflhf` | `git flow hotfix finish`   | Finish hotfix: `gflhf <version>`       |
| `gflrf` | `git flow release finish`  | Finish release: `gflrf <version>`      |
