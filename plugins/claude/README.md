# Claude Code plugin

This plugin provides aliases for the [Claude Code](https://code.claude.com/docs/en/cli) CLI.

To use it, add `claude` to the plugins array in your .zshrc file:

```zsh
plugins=(... claude)
```

## Aliases

| Alias | Command                 | Description                               |
|-------|-------------------------|-------------------------------------------|
| `cc`  | `claude`                | Interactive prompt                         |
| `ccx` | `claude --continue`     | Continue the most recent conversation      |
| `ccr` | `claude --resume`       | Resume a specific conversation by session  |
| `ccp` | `claude --print`        | Print response and exit (for pipes)        |
| `ccm` | `claude --model`        | Set the model for the current session      |
| `cch` | `claude --help`         | Show help                                 |