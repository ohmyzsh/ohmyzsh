# rsync

This plugin adds aliases for frequent [rsync](https://rsync.samba.org/) commands, simplifying file transfer and synchronization tasks.

To use it add `rsync` to the plugins array in you `.zshrc` file.

```zsh
plugins=(... rsync)
```

| Alias               | Command                                          | Description |
| ------------------- | ------------------------------------------------ | ------------|
| `rsync-copy`        | `rsync -avz --progress -h`                       | Recursively copy files and directories, preserving permissions, timestamps, and symbolic links. Compression is enabled for faster transfers. Progress is displayed in a human-readable format. | 
| `rsync-move`        | `rsync -avz --progress -h --remove-source-files` | Same as rsync-copy, but removes the source files after a successful transfer (effectively performing a move). | 
| `rsync-update`      | `rsync -avzu --progress -h`                      | Like rsync-copy, but only updates files if the source is newer than the destination (or if the destination file is missing). | 
| `rsync-synchronize` | `rsync -avzu --delete --progress -h`             | Performs bidirectional-style sync: updates files as in rsync-update and deletes files in the destination that no longer exist in the source. Useful for directory synchronization. | 

Explanation of Flags:
 - -a: Archive mode; preserves symbolic links, permissions, timestamps, etc.
 - -v: Verbose; shows details of the transfer process.
 - -z: Compress file data during transfer for efficiency.
 - -u: Skip files that are newer on the receiver.
 - --progress: Show progress during file transfer.
 - -h: Output numbers in human-readable format (e.g., 1K, 234M).
 - --remove-source-files: Deletes source files after they are copied (used in rsync-move).
 - --delete: Deletes files in the destination that are not present in the source (used in rsync-synchronize).
