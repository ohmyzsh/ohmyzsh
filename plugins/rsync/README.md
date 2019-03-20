# rsync

This plugin adds aliases for frequent [rsync](https://rsync.samba.org/) commands.

To use it add `rsync` to the plugins array in you zshrc file.

```zsh
plugins=(... rsync)
```

| Alias               | Command                                          |
| ------------------- | ------------------------------------------------ |
| *rsync-copy*        | `rsync -avz --progress -h`                       |
| *rsync-move*        | `rsync -avz --progress -h --remove-source-files` |
| *rsync-update*      | `rsync -avzu --progress -h`                      |
| *rsync-synchronize* | `rsync -avzu --delete --progress -h`             |
