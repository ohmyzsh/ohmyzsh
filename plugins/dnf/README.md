# dnf plugin

This plugin makes `dnf` usage easier by adding aliases for the most common commands.

`dnf` is the new package manager for RPM-based distributions, which replaces `yum`.

To use it, add `dnf` to the plugins array in your zshrc file:

```zsh
plugins=(... dnf)
```

## Aliases

| Alias | Command                 | Description              |
|-------|-------------------------|--------------------------|
| dnfl  | `dnf list`              | List packages            |
| dnfli | `dnf list installed`    | List installed packages  |
| dnfgl | `dnf grouplist`         | List package groups      |
| dnfmc | `dnf makecache`         | Generate metadata cache  |
| dnfp  | `dnf info`              | Show package information |
| dnfs  | `dnf search`            | Search package           |
| **Use `sudo`**                                             |
| dnfu  | `sudo dnf upgrade`      | Upgrade package          |
| dnfi  | `sudo dnf install`      | Install package          |
| dnfgi | `sudo dnf groupinstall` | Install package group    |
| dnfr  | `sudo dnf remove`       | Remove package           |
| dnfgr | `sudo dnf groupremove`  | Remove package group     |
| dnfc  | `sudo dnf clean all`    | Clean cache              |
