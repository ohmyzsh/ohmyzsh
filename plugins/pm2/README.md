# pm2 plugin

The plugin adds several aliases and completions for common [pm2](http://pm2.keymetrics.io/) commands.

To use it, add `pm2` to the plugins array of your zshrc file:
```
plugins=(... pm2)
```

## Aliases

| Alias  | Command              |
|--------|----------------------|
| p2s  | `pm2 start` |
| p2o  | `pm2 stop` |
| p2d | `pm2 delete` |
| p2r   | `pm2 restart` |
| p2i   | `pm2 list` |
| p2l   |  `pm2 logs` |
