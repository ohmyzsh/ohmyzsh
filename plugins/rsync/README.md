# rsync

This plugin adds 4 aliases for the open source [rsync](https://rsync.samba.org/) utility


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
