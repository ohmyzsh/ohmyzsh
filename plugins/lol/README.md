# lol

Plugin for adding catspeak aliases, because why not.

To use it, add `lol` to the plugins array in your zshrc file:

```zsh
plugins=(... lol)
```

## Aliases

| Alias        | Command                                                         |
| ------------ | --------------------------------------------------------------- |
| `:3`         | `echo`                                                          |
| `alwayz`     | `tail -f`                                                       |
| `bringz`     | `git pull`                                                      |
| `btw`        | `nice`                                                          |
| `byes`       | `exit`                                                          |
| `chicken`    | `git add`                                                       |
| `cya`        | `reboot`                                                        |
| `donotwant`  | `rm`                                                            |
| `dowant`     | `cp`                                                            |
| `gimmeh`     | `touch`                                                         |
| `gtfo`       | `mv`                                                            |
| `hackzor`    | `git init`                                                      |
| `hai`        | `cd`                                                            |
| `icanhas`    | `mkdir`                                                         |
| `ihasbucket` | `df -h`                                                         |
| `iminurbase` | `finger`                                                        |
| `inur`       | `locate`                                                        |
| `invisible`  | `cat`                                                           |
| `iz`         | `ls`                                                            |
| `kthxbai`    | `halt`                                                          |
| `letcat`     | `git checkout`                                                  |
| `moar`       | `more`                                                          |
| `nomnom`     | `killall`                                                       |
| `nomz`       | `ps aux`                                                        |
| `nowai`      | `chmod`                                                         |
| `oanward`    | `git commit -m`                                                 |
| `obtw`       | `nohup`                                                         |
| `onoz`       | `cat /var/log/errors.log`                                       |
| `ooanward`   | `git commit -am`                                                |
| `plz`        | `pwd`                                                           |
| `pwned`      | `ssh`                                                           |
| `rtfm`       | `man`                                                           |
| `rulz`       | `git push`                                                      |
| `tldr`       | `less`                                                          |
| `violenz`    | `git rebase`                                                    |
| `visible`    | `echo`                                                          |
| `wtf`        | `dmesg`                                                         |
| `yolo`       | `git commit -m "$(curl -s https://whatthecommit.com/index.txt)"` |

## Usage Examples

```sh
# mkdir new-directory
icanhas new-directory

# killall firefox
nomnom firefox

# chmod u=r,go= some.file
nowai u=r,go= some.file

# ssh root@catserver.org
pwned root@catserver.org

# git commit -m "$(curl -s https://whatthecommit.com/index.txt)"
yolo
```
