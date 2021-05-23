# dnf plugin

This plugin makes `dnf` usage easier by adding aliases (strongly inspired by zypper official aliases) for the most common commands.

`dnf` is the new package manager for RPM-based distributions, which replaces `yum`.

To use it, add `dnf` to the plugins array in your zshrc file:

```zsh
plugins=(... dnf)
```

## Aliases

| Alias          | Command                      | Description              |
| -------------- | ---------------------------- | ------------------------ |
| d              | `dnf`                        | Dnf app itself           |
| dh             | `dnf -h`                     | Get help                 |
| dl             | `dnf list`                   | List packages            |
| dli            | `dnf list installed`         | List installed packages  |
| dgl            | `dnf grouplist`              | List package groups      |
| dref           | `dnf makecache`              | Generate metadata cache  |
| dif            | `dnf info`                   | Show package information |
| dse            | `dnf search`                 | Search package           |
| **Use `sudo`** |
| din            | `sudo dnf install`           | Install package          |
| dgin           | `sudo dnf groupinstall`      | Install package group    |
| drein          | `sudo dnf reinstall`         | Reinstall package        |
| ddl            | `sudo dnf download`          | Download RPM             |
| dup            | `sudo dnf upgrade`           | Upgrade package          |
| ddup           | `sudo dnf distro-sync`       | Distro-Syncs             |
| dcup           | `sudo dnf check-update`      | Check for updates        |
| drm            | `sudo dnf remove`            | Remove package           |
| dgrm           | `sudo dnf groupremove`       | Remove package group     |
| dar            | `sudo dnf autoremove`        | Clean dependencies       |
| dcall          | `sudo dnf clean all`         | Clean cache              |
| dshell         | `sudo dnf shell`             | Enters dnf shell         |
| dsdl           | `sudo dnf download --source` | Download package source  |
