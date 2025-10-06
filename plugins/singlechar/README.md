# Singlechar plugin

This plugin adds single char shortcuts (and combinations) for some commands.

To use it, add `singlechar` to the plugins array of your zshrc file:
```
plugins=(... singlechar)
```

## Aliases

### CAT, GREP, CURL, WGET

| Alias | Command          | Description |
|-------|------------------|-------------|
| y     | `grep -Ri`       | Find case-insensitive string in all files and directories, recursively. Follows symlinks. |
| n     | `grep -Rvi`      | Same as above but only show lines that don't match the string.                            |
| f     | `grep -Rli`      | Same as 'y' but only print the filenames where the string is found.                       |
| fn    | `grep -Rlvi`     | Same as above but only show files that don't contain the string.                          |
| f.    | `find . \| grep` | Grep list of files in current directory                                                   |
| f:    | `find`           | 'find' command                                                                            |
| p     | `less`           | 'less' command                                                                            |
| m     | `man`            | 'man' command                                                                             |
| d     | `wget`           | 'wget' command                                                                            |
| u     | `curl`           | 'curl' command                                                                            |
| c     | `cat`            | 'cat' command                                                                             |
| w     | `echo >`         | Write arguments to file, overwriting it if it exists.                                     |
| a     | `echo >>`        | Write arguments to file, appending them if the file exists.                               |
| w:    | `cat >`          | Write stdin to file, overwriting if it exists.                                            |
| a:    | `cat >>`         | Write stdin to file, appending it if the file exists.                                     |

### XARGS

These aliases are versions of the aliases above but using xargs. This can be used
by piping the arguments to the xargs aliases.

| Alias | Command              | Description                     |
|-------|----------------------|---------------------------------|
| x     | `xargs`              | 'xargs' command                 |
| xy    | `xargs grep -Ri`     | Same as 'y' alias using xargs.  |
| xn    | `xargs grep -Rvi`    | Same as 'n' alias using xargs.  |
| xf    | `xargs grep -Rli`    | Same as 'f' alias using xargs.  |
| xfn   | `xargs grep -Rlvi`   | Same as 'fn' alias using xargs. |
| xf.   | `xargs find \| grep` | Same as 'f.' alias using xargs. |
| xf:   | `xargs find`         | Same as 'f:' alias using xargs. |
| xc    | `xargs cat`          | Same as 'c' alias using xargs.  |
| xp    | `xargs less`         | Same as 'p' alias using xargs.  |
| xm    | `xargs man`          | Same as 'm' alias using xargs.  |
| xd    | `xargs wget`         | Same as 'd' alias using xargs.  |
| xu    | `xargs curl`         | Same as 'u' alias using xargs.  |
| xw    | `xargs echo >`       | Same as 'w' alias using xargs.  |
| xa    | `xargs echo >>`      | Same as 'a' alias using xargs.  |
| xw:   | `xargs cat >`        | Same as 'w:' alias using xargs. |
| xa:   | `xargs >>`           | Same as 'a:' alias using xargs. |

### SUDO

These aliases are versions of the aliases above in [CAT, GREP, CURL, WGET](#cat-grep-curl-wget)
but using sudo to run them with root permission.

| Alias | Command               | Description                    |
|-------|-----------------------|--------------------------------|
| s     | `sudo`                | 'sudo' command                 |
| sy    | `sudo grep -Ri`       | Same as 'y' alias using sudo.  |
| sn    | `sudo grep -Riv`      | Same as 'n' alias using sudo.  |
| sf    | `sudo grep -Rli`      | Same as 'f' alias using sudo.  |
| sfn   | `sudo grep -Rlvi`     | Same as 'fn' alias using sudo. |
| sf.   | `sudo find . \| grep` | Same as 'f.' alias using sudo. |
| sf:   | `sudo find`           | Same as 'f:' alias using sudo. |
| sp    | `sudo less`           | Same as 'p' alias using sudo.  |
| sm    | `sudo man`            | Same as 'm' alias using sudo.  |
| sd    | `sudo wget`           | Same as 'd' alias using sudo.  |
| sc    | `sudo cat`            | Same as 'c' alias using sudo.  |
| sw    | `sudo echo >`         | Same as 'w' alias using sudo.  |
| sa    | `sudo echo >>`        | Same as 'a' alias using sudo.  |
| sw:   | `sudo cat >`          | Same as 'w:' alias using sudo. |
| sa:   | `sudo cat >>`         | Same as 'a:' alias using sudo. |

### SUDO-XARGS

Same as above but using both sudo and xargs.

| Alias | Command                   | Description                     |
|-------|---------------------------|---------------------------------|
| sx    | `sudo xargs`              | 'sudo xargs' command            |
| sxy   | `sudo xargs grep -Ri`     | Same as 'xy' alias using sudo.  |
| sxn   | `sudo xargs grep -Riv`    | Same as 'xn' alias using sudo.  |
| sxf   | `sudo xargs grep -li`     | Same as 'xf' alias using sudo.  |
| sxfn  | `sudo xargs grep -lvi`    | Same as 'xfn' alias using sudo. |
| sxf.  | `sudo xargs find \| grep` | Same as 'xf.' alias using sudo. |
| sxf:  | `sudo xargs find`         | Same as 'xf:' alias using sudo. |
| sxp   | `sudo xargs less`         | Same as 'xp' alias using sudo.  |
| sxm   | `sudo xargs man`          | Same as 'xm' alias using sudo.  |
| sxd   | `sudo xargs wget`         | Same as 'xd' alias using sudo.  |
| sxu   | `sudo xargs curl`         | Same as 'xu' alias using sudo.  |
| sxc   | `sudo xargs cat`          | Same as 'xc' alias using sudo.  |
| sxw   | `sudo xargs echo >`       | Same as 'xw' alias using sudo.  |
| sxa   | `sudo xargs echo >>`      | Same as 'xa' alias using sudo.  |
| sxw:  | `sudo xargs cat >`        | Same as 'xw:' alias using sudo. |
| sxa:  | `sudo xargs cat >>`       | Same as 'xa:' alias using sudo. |

## Options

The commands `grep`, `sudo`, `wget`, `curl`, and `less` can be configured to use other commands
via the setup variables below, before Oh My Zsh is sourced. If they are not set yet, they will
use their default values:

| Setup variable | Default value |
|----------------|---------------|
| GREP           | `grep`        |
| ROOT           | `sudo`        |
| WGET           | `wget`        |
| CURL           | `curl`        |
| PAGER          | `less`        |

## Author

- [Karolin Varner](https://github.com/koraa)
