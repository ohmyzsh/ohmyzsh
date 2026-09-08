# Systemd plugin

This plugin provides easy aliases and functions for working with `systemctl` commands, making service management more convenient. It includes both system-wide and user-level service commands, as well as functions for toggling, restarting, and checking service statuses.

## Installation

To use this plugin, add `systemd` to the plugins array in your `.zshrc` file:

```
plugins=(... systemd)
```
 > Once added, either restart your terminal or run `source ~/.zshrc` to apply the changes.

## Commands and Aliases 

| Alias | Command | Description |
|---------------|-------------|-------|
| `sc` | `sudo systemctl` | System-wide systemctl |
| `scr` | `sudo systemctl restart` | Restart a system-wide service |
| `scs` | `sudo systemctl start` | Start a system-wide service | 
| `sctp` | `sudo systemctl stop` | Stop a system-wide service |
| `scst` | `sudo systemctl status` | Check the status of a system-wide service |
| `sce` | `sudo systemctl enable` | Enable a system-wide service | 
| `scen` | `sudo systemctl enable --now` | Enable and start unit |
| `scre` | `sudo systemctl reenable` | Reenable unit | 
| `scd` | `sudo systemctl disable` | Disable a system-wide service |
| `scdn` | `sudo systemctl disable --now` | Disable and stop unit |
| `screl` | `sudo systemctl reload` | Reload a system-wide service | 
| `scres` | `sudo systemctl restart` | Restart system-wide service |
| `sctr` | `sudo systemctl try-restart` | Restart system-wide service | 
| `scisol` | `sudo systemctl isolate` | Start a unit and its dependencies and stop all others | 
| `sckill` | `sudo systemctl kill` | Kill unit |
| `scresfail` | `sudo systemctl reset-failed` | Reset the failed state of the specified units |
| `scpres` | `sudo systemctl preset` | Reset the enable/disable status one or more unit files |
| `scmask` | `sudo systemctl mask` | Mask unit | 
| `scunmask` | `sudo systemctl unmask` | Unmask unit |
| `scmaskn` | `sudo systemctl mask --now` | Mask and stop unit |
| `sclink` | `sudo systemctl link` | Link a unit file into the unit file search path |
| `scload` | `sudo systemctl load` | Load unit |
| `sccnl` | `sudo systemctl cancel` | Cancel job |
| `scstenv` | `sudo systemctl set-environment` | Set one or more systemd manager environment variables |
| `scunstenv` | `sudo systemctl unset-environment` | Unset one or more systemd manager environment variables |
| `scedt` | `sudo systemctl edit` | Edit a drop-in snippet or a whole replacement file with --full |
| `scia` | `systemctl is-active` | Show whether a unit is active | 
| `scie` | `systemctl is-enabled` | Checks whether any of the specified unit files are enabled | 
| `scsh` | `systemctl show` | Show properties of units, jobs, or the manager itself | 
| `schelp` | `systemctl help` | Show man page of units |
| `scshenv` | `systemctl show-environment` | Dump the systemd manager environment block | 
| `sccat` | `systemctl cat` | Show backing files of one or more units |
| `scu` | `systemctl --user` | User-level systemctl |
| `scur` | `systemctl --user restart` | Restart a user-level service |
| `scus` | `systemctl --user start` | Start a user-level service |
| `scup` | `systemctl --user stop` | Stop a user-level service | 
| `scust` | `systemctl --user status` | Check the status of a user-level service |
| `scue` | `systemctl --user enable` | Enable a user-level service |
| `scud` | `systemctl --user disable` | Disable a user-level service |
| `scure` | `systemctl --use reload` | Reload a user-level service |
| `scls` | `systemctl list-units --type=service` | List active services | 
| `sclsa` | `systemctl list-units --type=service --all` | List all services | 
| `sclsf` | `systemctl list-units --type=service --failed` | List failed services | 
| `sclsr` | `systemctl list-units --type=service --state=runnings` | List running services | 
| `sclf` | `systemctl list-unit-files` | List unit files installed on the system | 
| `sclj` | `systemctl list-jobs` | List jobs that are in progress | 
| `sclt` | `systemctl list-timers` | List active timers | 
| `sclta` | `systemctl list-timers --all` | List all timers | 
| `jc` | `sudo journalctl` | View system logs | 
| `jcf` | `sudo journalctl -f` | Follow system logs |
| `jcb` | `sudo journalctl -b` | View the logs from the current boot | 
| `jcl` | `sudo journalctl --since "1 hour ago"` | View logs from the past hour |
| `jcu` | `sudo journalctl -u` | View logs for a specific service |

## Functions 

 - `scheck`: Check the status and enablement of a service 
    - Usage: `scheck <service_name>`
    - Example: `scheck httpd`
 - `stoggle`: Toggle a service (start if stopped, stop if started)
    - Usage: `stoggle <service_name>`
    - Example: `stoggle httpd`
 - `srestart`: Restart a service and show its status
    - Usage: `srestart <service_name`
    - Example: `srestart httpd`
 - `slogs`: Show the last few log entries for a service
    - Usage: `slogs <service_name> [number_of_lines]`
    - Example: `slogs httpd 50`
 - `swatchlog`: Watch the logs of a service in real-time
    - Usage: `swatchlog <service_name>`
    - Example: `swatchlog httpd` 
 - `smulti`: Manage multiple services at once (start, stop, restart, or check status)
    - Usage: `smulti [start|stop|restart|status] <service1> <service2> ...`
    - Example: `smulti start httpd mariadb`
 - `sfind`: Search for systemd units 
    - Usage: `sfind <search_pattern>`
    - Example: `sfind http`

This plugin should help streamline your work with `systemctl` commands and save you time when managing services on your system.
