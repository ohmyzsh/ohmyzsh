# exa Plugin

This plugin creates helpful shortcut aliases for many commonly used `exa` commands.

To use it add `exa` to the plugins array in your zshrc file:

```zsh
plugins=(... exa)
```

## Aliases

### exa command

| Alias | Command             | Description                                                                    |
|-------|---------------------|--------------------------------------------------------------------------------|
| l     | `exa -lgFHh`        | List files as a long list, show size, type, human-readable                     |
| la    | `exa -lgaFHh`       | List almost all files as a long list show size, type, human-readable           |
| lr    | `exa -lgrRFHhs=mod` | List files recursively sorted by date, show type, human-readable               |
| lt    | `exa -lgrFHhs=mod`  | List files as a long list sorted by date, show type, human-readable            |
| ll    | `exa -lgHh`         | List files as a long list                                                      |
| ldot  | `exa -ldgHh .*`     | List dot files as a long list                                                  |
| lS    | `exa -lrhs=size`    | List files sorted by size                                                      |
| lart  | `exa -1Fahs=mod`    | List all files sorted in reverse of create/modification time (oldest first)    |
| lrt   | `exa -1Frhs=mod`    | List files sorted in reverse of create/modification time(oldest first)         |
