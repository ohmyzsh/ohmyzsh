# Common Aliases Plugin

This plugin creates helpful shortcut aliases for many commonly used commands.

To use it add `common-aliases` to the plugins array in your zshrc file:

```zsh
plugins=(... common-aliases)
```

## Aliases

### ls command

| Alias | Command                                   | Description                                                                    |
|-------|-------------------------------------------|--------------------------------------------------------------------------------|
| l     | `ls -lFh`                                 | List files as a long list, show size, type, human-readable                     |
| la    | `ls -lAFh`                                | List almost all files as a long list show size, type, human-readable           |
| lr    | `ls -tRFh`                                | List files recursively sorted by date, show type, human-readable               |
| lt    | `ls -ltFh`                                | List files as a long list sorted by date, show type, human-readable            |
| ll    | `ls -l`                                   | List files as a long list                                                      |
| ldot  | `ls -ld .*`                               | List dot files as a long list                                                  |
| lS    | `ls -1FSsh`                               | List files showing only size and name sorted by size                           |
| lart  | `ls -1Fcart`                              | List all files sorted in reverse of create/modification time (oldest first)    |
| lrt   | `ls -1Fcrt`                               | List files sorted in reverse of create/modification time(oldest first)         |

### File handling

| Alias | Command                                   | Description                                                                        |
|-------|-------------------------------------------|------------------------------------------------------------------------------------|
| rm    | `rm -i`                                   | Remove a file                                                                      |
| cp    | `cp -i`                                   | Copy a file                                                                        |
| mv    | `mv -i`                                   | Move a file                                                                        |
| zshrc | `${=EDITOR} ~/.zshrc`                     | Quickly access the ~/.zshrc file                                                   |
| dud   | `du -d 1 -h`                              | Display the size of files at depth 1 in current location in human-readable form    |
| duf   | `du -sh`                                  | Display the size of files in current location in human-readable form               |

### find and grep

| Alias | Command                                             | Description                             |
|-------|-----------------------------------------------------|-----------------------------------------|
| fd    | `find . -type d -name`                              | Find a directory with the given name    |
| ff    | `find . -type f -name`                              | Find a file with the given name         |
| grep  | `grep --color`                                      | searches for a query string             |
| sgrep | `grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS}`  | useful for searching within files       |
