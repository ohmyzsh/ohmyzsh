# ips plugin

**Maintainer:** [@Frani](https://github.com/frani)

This plugin provides completion as well as adding many useful aliases.

To use it, add `ips` to the plugins array in your zshrc file:

```zsh
plugins=(... ips)
```

## Aliases

| Alias         | Command                                                                                                           | Description                         |
|---------------|-------------------------------------------------------------------------------------------------------------------|-------------------------------------|
| ipe           | `curl -s ipv4.icanhazip.com`                                                                                      | Display your current external ip v4 |
| ipi           | `ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*'| grep -Eo '([0-9]*\.){3}[0-9]*'   | grep -v '127.0.0.1'`  | Display your current internal ip v4 |
