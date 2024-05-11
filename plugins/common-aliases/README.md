# Common Aliases Plugin

This plugin creates helpful shortcut aliases for many commonly used commands.

To use it add `common-aliases` to the plugins array in your zshrc file:

```zsh
plugins=(... common-aliases)
```

## Aliases

### ls command

| Alias | Command      | Description                                                                 |
| ----- | ------------ | --------------------------------------------------------------------------- |
| l     | `ls -lFh`    | List files as a long list, show size, type, human-readable                  |
| la    | `ls -lAFh`   | List almost all files as a long list show size, type, human-readable        |
| lr    | `ls -tRFh`   | List files recursively sorted by date, show type, human-readable            |
| lt    | `ls -ltFh`   | List files as a long list sorted by date, show type, human-readable         |
| ll    | `ls -l`      | List files as a long list                                                   |
| ldot  | `ls -ld .*`  | List dot files as a long list                                               |
| lS    | `ls -1FSsh`  | List files showing only size and name sorted by size                        |
| lart  | `ls -1Fcart` | List all files sorted in reverse of create/modification time (oldest first) |
| lrt   | `ls -1Fcrt`  | List files sorted in reverse of create/modification time(oldest first)      |
| lsr   | `ls -lARFh`  | List all files and directories recursively                                  |
| lsn   | `ls -1`      | List files and directories in a single column                               |

### File handling

| Alias | Command               | Description                                                                     |
| ----- | --------------------- | ------------------------------------------------------------------------------- |
| rm    | `rm -i`               | Remove a file                                                                   |
| cp    | `cp -i`               | Copy a file                                                                     |
| mv    | `mv -i`               | Move a file                                                                     |
| zshrc | `${=EDITOR} ~/.zshrc` | Quickly access the ~/.zshrc file                                                |
| dud   | `du -d 1 -h`          | Display the size of files at depth 1 in current location in human-readable form |
| duf\* | `du -sh`              | Display the size of files in current location in human-readable form            |
| t     | `tail -f`             | Shorthand for tail which outputs the last part of a file                        |

\* Only if the [`duf`](https://github.com/muesli/duf) command isn't installed.

### find and grep

| Alias | Command                                            | Description                          |
| ----- | -------------------------------------------------- | ------------------------------------ |
| fd\*  | `find . -type d -name`                             | Find a directory with the given name |
| ff    | `find . -type f -name`                             | Find a file with the given name      |
| grep  | `grep --color`                                     | Searches for a query string          |
| sgrep | `grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS}` | Useful for searching within files    |

\* Only if the [`fd`](https://github.com/sharkdp/fd) command isn't installed.

### Other Aliases

| Alias    | Command            | Description                                                 |
| -------- | ------------------ | ----------------------------------------------------------- |
| h        | `history`          | Lists all recently used commands                            |
| hgrep    | `fc -El 0 \| grep` | Searches for a word in the list of previously used commands |
| help     | `man`              | Opens up the man page for a command                         |
| p        | `ps -f`            | Displays currently executing processes                      |
| sortnr   | `sort -n -r`       | Used to sort the lines of a text file                       |
| unexport | `unset`            | Used to unset an environment variable                       |

## Global aliases

These aliases are expanded in any position in the command line, meaning you can use them even at the
end of the command you've typed. Examples:

Quickly pipe to less:

```zsh
$ ls -l /var/log L
# will run
$ ls -l /var/log | less
```

Silences stderr output:

```zsh
$ find . -type f NE
# will run
$ find . -type f 2>/dev/null
```

| Alias | Command                     | Description                                                 |
| ----- | --------------------------- | ----------------------------------------------------------- |
| H     | `\| head`                   | Pipes output to head which outputs the first part of a file |
| T     | `\| tail`                   | Pipes output to tail which outputs the last part of a file  |
| G     | `\| grep`                   | Pipes output to grep to search for some word                |
| L     | `\| less`                   | Pipes output to less, useful for paging                     |
| M     | `\| most`                   | Pipes output to more, useful for paging                     |
| LL    | `2>&1 \| less`              | Writes stderr to stdout and passes it to less               |
| CA    | `2>&1 \| cat -A`            | Writes stderr to stdout and passes it to cat                |
| NE    | `2 > /dev/null`             | Silences stderr                                             |
| NUL   | `> /dev/null 2>&1`          | Silences both stdout and stderr                             |
| P     | `2>&1\| pygmentize -l pytb` | Writes stderr to stdout and passes it to pygmentize         |

## File extension aliases

These are special aliases that are triggered when a file name is passed as the command. For example,
if the pdf file extension is aliased to `acroread` (a popular Linux pdf reader), when running `file.pdf`
that file will be open with `acroread`.

### Reading Docs

| Alias | Command    | Description                        |
| ----- | ---------- | ---------------------------------- |
| pdf   | `acroread` | Opens up a document using acroread |
| ps    | `gv`       | Opens up a .ps file using gv       |
| dvi   | `xdvi`     | Opens up a .dvi file using xdvi    |
| chm   | `xchm`     | Opens up a .chm file using xchm    |
| djvu  | `djview`   | Opens up a .djvu file using djview |

### Listing files inside a packed file

| Alias  | Command    | Description                       |
| ------ | ---------- | --------------------------------- |
| zip    | `unzip -l` | Lists files inside a .zip file    |
| rar    | `unrar l`  | Lists files inside a .rar file    |
| tar    | `tar tf`   | Lists files inside a .tar file    |
| tar.gz | `echo`     | Lists files inside a .tar.gz file |
| ace    | `unace l`  | Lists files inside a .ace file    |

### Some other features

- Opens urls in terminal using browser specified by the variable `$BROWSER`
- Opens C, C++, Tex and text files using editor specified by the variable `$EDITOR`
- Opens images using image viewer specified by the variable `$XIVIEWER`
- Opens videos and other media using mplayer
