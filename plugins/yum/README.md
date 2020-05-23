# Yum plugin

This plugin adds useful aliases for common [Yum](http://yum.baseurl.org/) commands.

To use it, add `yum` to the plugins array in your zshrc file:

```zsh
plugins=(... yum)
```

## Aliases

| Alias | Command                           | Description                  |
|-------|-----------------------------------|------------------------------|
| ys    | `yum search`                      | Search package               |
| yp    | `yum info`                        | Show package info            |
| yl    | `yum list`                        | List packages                |
| ygl   | `yum grouplist`                   | List package groups          |
| yli   | `yum list installed`              | Print all installed packages |
| ymc   | `yum makecache`                   | Rebuild the yum package list |
| yu    | `sudo yum update`                 | Upgrade packages             |
| yi    | `sudo yum install`                | Install package              |
| ygi   | `sudo yum groupinstall`           | Install package group        |
| yr    | `sudo yum remove`                 | Remove package               |
| ygr   | `sudo yum groupremove`            | Remove pagage group          |
| yrl   | `sudo yum remove --remove-leaves` | Remove package and leaves    |
| yc    | `sudo yum clean all`              | Clean yum cache              |
