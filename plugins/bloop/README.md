# bloop plugin

The plugin adds several aliases for common [bloop](https://scalacenter.github.io/bloop/) commands.

To use it, add `bloop` to the plugins array of your zshrc file:

```zsh
plugins=(... bloop)
```

## Aliases

| Alias    | Command                               | Description                                                         |
|----------|---------------------------------------|---------------------------------------------------------------------|
| `bp`     | `bloop projects`                      | List the projects in current repository                             |
| `bc`     | `bloop compile `                      | Compile the project                                                 |
| `bcl`    | `bloop clean `                        | Clean the project                                                   |
| `br`     | `bloop run `                          | Run the project                                                     |
