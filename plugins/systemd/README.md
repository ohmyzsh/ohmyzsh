##
systemd plugin

The systemd plugin provides completion as well as adding many useful aliases for systemd.

To use it, add systemd to the plugins array of your zshrc file:
```
plugins=(... systemd)
```

## Aliases

| Alias                | Command                       | Descripton                                                      |
|:---------------      |:------------------------------|:----------------------------------------------------------------|
| `sc-list-units`      | `systemtl list-units`         | List all units systemd has in memory                            |
| `sc-is-active`       | `systemtl is-active`          | Show whether a unit is active                                   |
| `sc-status`          | `systemtl status`             | Show terse runtime status information about one or more units   |
| `sc-show`            | `systemtl show`               | Show properties of one or more units, jobs, or the manager itself|
| `sc-help`            | `systemtl help`               | Show man page of units                                          |
| `sc-list-unit-files` | `systemtl list-unit-files`    | List unit files installed on the system                         |
| `sc-is-enabled`      | `systemtl is-enabled`         | Checks whether any of the specified unit files are enabled      |
| `sc-list-jobs`       | `systemtl list-jobs`          | List jobs that are in progress                                  |
| `sc-show-environment`| `systemtl show-environment`   | Dump the systemd manager environment block                      |
| `sc-cat`             | `systemtl cat`                | Show backing files of one or more units                         |
| `sc-list-timers`     | `systemtl list-timers`        | List timer units currently in memory                            |
| `sc-start`           | `sudo systemtl start`         | Start Unit(s)                                                   |
| `sc-stop`            | `sudo systemtl stop`          | Stop Unit(s)                                                    |
| `sc-reload`          | `sudo systemtl reload`        | Reload Unit(s)                                                  |
| `sc-restart`         | `sudo systemtl restart`       | Restart Unit(s)                                                 |
| `sc-try-restart`     | `sudo systemtl try-restart`   | Restart Unit(s)                                                 |
| `sc-isolate`         | `sudo systemtl isolate`       | Start the unit specified on the command line and its dependencies and stop all others|
| `sc-kill`            | `sudo systemtl kill`          | Kill unit(s)                                                    |
| `sc-reset-failed`    | `sudo systemtl reset-failed`  | Reset the "failed" state of the specified units,                |
| `sc-enable`          | `sudo systemtl enable`        | Enable unit(s)                                                  |
| `sc-disable`         | `sudo systemtl disable`       | Disable unit(s)                                                 |
| `sc-reenable`        | `sudo systemtl reenable`      | Reenable unit(s)                                                |
| `sc-preset`          | `sudo systemtl preset`        | Reset the enable/disable status one or more unit files          |
| `sc-mask`            | `sudo systemtl mask`          | Mask unit(s)                                                    |
| `sc-unmask`          | `sudo systemtl unmask`        | Unmask unit(s)                                                  |
| `sc-link`            | `sudo systemtl link`          | Link a unit file that is not in the unit file search paths into the unit file search path|
| `sc-load`            | `sudo systemtl load`          | Load unit(s)                                                    |
| `sc-cancel`          | `sudo systemtl cancel`        | Cancel job(s)                                                   |
| `sc-set-environment` | `sudo systemtl set-environment`| Set one or more systemd manager environment variables          |
| `sc-unset-environment`| `sudo systemtl unset-environment`|  Unset one or more systemd manager environment variables    |
| `sc-edit`            | `sudo systemtl edit`          | Edit a drop-in snippet or a whole replacement file if --full is specified |
| `sc-enable-now`      | `sudo systemtl enable --now`  | Enable and start unit(s)                                        |
| `sc-disable-now`     | `sudo systemtl disable --now` | Disable and stop unit(s)                                        |
| `sc-mask-now`        | `sudo systemtl mask --now`    | Mask and stop unit(s)                                           |


In the above aliases, instead of prefix sc, scu can be used to add --user flag to the commands

Example:

`scu-list-units` will be aliased to `systemctl --user list-units`