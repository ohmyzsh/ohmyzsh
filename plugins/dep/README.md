# Dep plugin

This plugin adds completion for the [Dep - Dependency management for Go](https://golang.github.io/dep/),
as well as some aliases for common Dep commands.

To use it, add `dep` to the plugins array in your zshrc file:

```zsh
plugins=(... dep)
```

## Aliases

| Alias | Command                                   | Description                                                                                                   |
|-------|-------------------------------------------|---------------------------------------------------------------------------------------------------------------|
| depc  | `dep check`                               | Check if imports, `Gopkg.toml`, and `Gopkg.lock` are in sync                                                  |
| deps  | `dep status`                              | Report the status of the project dependencies                                                                 |
| depe  | `dep ensure`                              | Ensure a dependency is safely vendored in the project                                                         |
| depa  | `dep ensure -add`                         | Add new dependencies, or populate `Gopkg.toml` with constraints for existing dependencies                     |
| depu  | `dep ensure -update`                      | update the named dependencies (or all, if none are named) in Gopkg.lock to the latest allowed by `Gopkg.toml` |
