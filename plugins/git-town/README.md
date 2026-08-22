# Git-Town plugin

This plugin adds completion and aliases for the `git-town` command. More information
at https://www.git-town.com.

Enable git-town plugin in your zshrc file:
```
plugins=(... git-town)
```

## Aliases

More information about `git-town` commands:
https://github.com/Originate/git-town#commands

| Alias   | Command                    | Description                            |
|---------|----------------------------|----------------------------------------|
| `gt`    | `git town`                 | Git-Town command                       |
| `gtab`  | `git town abort`           | Aborts the last run git-town command   |
| `gtc`   | `git town continue`        | Restarts last after resolved conflict  |
| `gth`   | `git town hack`            | New feature branch off main branch     |
| `gtsy`  | `git town sync`            | Updates current branch w/ all changes  |
| `gtnpr` | `git town new-pull-request`| Create a new pull request              |
| `gtsh`  | `git town ship`            | Delivers feature branch and removes it |
