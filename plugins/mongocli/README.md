# mongocli plugin

The plugin adds several aliases for common [mongocli](https://docs.mongodb.com/mongocli/stable/) commands.

To use it, add `mongocli` to the plugins array of your zshrc file:

```zsh
plugins=(... mongocli)
```

## Aliases

| Alias    | Command                                                     | Description                                            |
|----------|-------------------------------------------------------------|--------------------------------------------------------|
| `ma`     | `mongocli atlas`                                            | Shortcut for mongocli Atlas commands.                  |
| `mcm`    | `mongocli cloud-manager`                                    | Shortcut for mongocli Cloud Manager commands.          |
| `mom`    | `mongocli ops-manager`                                      | Shortcut for mongocli Cloud Manager commands.          |
| `miam`   | `mongocli iam`                                              | Shortcut for mongocli IAM commands.                    |

