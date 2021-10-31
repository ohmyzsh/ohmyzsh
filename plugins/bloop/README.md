# bloop plugin

The plugin adds several aliases for common [bloop](https://scalacenter.github.io/bloop/) commands.

To use it, add `bloop` to the plugins array of your zshrc file:

```zsh
plugins=(... bloop)
```

## Aliases

| Alias    | Command                               | Description                                                         |
|----------|---------------------------------------|---------------------------------------------------------------------|
| `bp`     | `brew projects`                       | List the projects in current repository                             |
| `bc`     | `brew compile `                       | Compile the project                                                 |
| `bcl`    | `brew clean `                         | Clean the project                                                   |
| `br`     | `brew run `                           | Run the project                                                     |
