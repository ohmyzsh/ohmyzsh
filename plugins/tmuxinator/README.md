# Tmuxinator plugin

This plugin provides 4 aliases for tmuxinator commands.

To use it add `tmuxinator` to the plugins array in your zshrc file.

```zsh
plugins=(... tmuxinator)
```

## Aliases

| Alias  | Command          | Description              |
| ------ | ---------------- | ------------------------ |
| `txs ` | tmuxinator start | Start                    |
| `txo ` | tmuxinator open  | Open project for editing |
| `txn ` | tmuxinator new   | Create project           |
| `txl ` | tmuxinator list  | List projects            |
