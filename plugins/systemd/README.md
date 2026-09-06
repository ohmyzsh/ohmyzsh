# Systemd plugin

The systemd plugin provides many useful aliases for systemd.

To use it, add systemd to the plugins array of your zshrc file:

```zsh
plugins=(... systemd)
```

## Aliases

| Alias                  | Command                             | Description                                                      |
|:-----------------------|:------------------------------------|:-----------------------------------------------------------------|
| `sc-failed`            | `systemctl --failed`                | List failed systemd units                                        |
| `sc-list-units`        | `systemctl list-units`              | List all units systemd has in memory                             |
| `sc-is-active`         | `systemctl is-active`               | Show whether a unit is active                                    |
| `sc-status`            | `systemctl status`                  | Show terse runtime status information about one or more units    |
| `sc-show`              | `systemctl show`                    | Show properties of units, jobs, or the manager itself            |
| `sc-help`              | `systemctl help`                    | Show man page of units                                           |
| `sc-list-unit-files`   | `systemctl list-unit-files`         | List unit files installed on the system                          |
| `sc-is-enabled`        | `systemctl is-enabled`              | Checks whether any of the specified unit files are enabled       |
| `sc-list-jobs`         | `systemctl list-jobs`               | List jobs that are in progress                                   |
| `sc-show-environment`  | `systemctl show-environment`        | Dump the systemd manager environment block                       |
| `sc-cat`               | `systemctl cat`                     | Show backing files of one or more units                          |
| `sc-list-timers`       | `systemctl list-timers`             | List timer units currently in memory                             |
| **Privileged aliases**                                                                                                        |||
| `sc-start`             | `$SUDO systemctl start`             | Start Unit(s)                                                    |
| `sc-stop`              | `$SUDO systemctl stop`              | Stop Unit(s)                                                     |
| `sc-reload`            | `$SUDO systemctl reload`            | Reload Unit(s)                                                   |
| `sc-restart`           | `$SUDO systemctl restart`           | Restart Unit(s)                                                  |
| `sc-try-restart`       | `$SUDO systemctl try-restart`       | Restart Unit(s)                                                  |
| `sc-isolate`           | `$SUDO systemctl isolate`           | Start a unit and its dependencies and stop all others            |
| `sc-kill`              | `$SUDO systemctl kill`              | Kill unit(s)                                                     |
| `sc-reset-failed`      | `$SUDO systemctl reset-failed`      | Reset the "failed" state of the specified units,                 |
| `sc-enable`            | `$SUDO systemctl enable`            | Enable unit(s)                                                   |
| `sc-disable`           | `$SUDO systemctl disable`           | Disable unit(s)                                                  |
| `sc-reenable`          | `$SUDO systemctl reenable`          | Reenable unit(s)                                                 |
| `sc-preset`            | `$SUDO systemctl preset`            | Reset the enable/disable status one or more unit files           |
| `sc-mask`              | `$SUDO systemctl mask`              | Mask unit(s)                                                     |
| `sc-unmask`            | `$SUDO systemctl unmask`            | Unmask unit(s)                                                   |
| `sc-link`              | `$SUDO systemctl link`              | Link a unit file into the unit file search path                  |
| `sc-load`              | `$SUDO systemctl load`              | Load unit(s)                                                     |
| `sc-cancel`            | `$SUDO systemctl cancel`            | Cancel job(s)                                                    |
| `sc-set-environment`   | `$SUDO systemctl set-environment`   | Set one or more systemd manager environment variables            |
| `sc-unset-environment` | `$SUDO systemctl unset-environment` | Unset one or more systemd manager environment variables          |
| `sc-edit`              | `$SUDO systemctl edit`              | Edit a drop-in snippet or a whole replacement file with `--full` |
| `sc-enable-now`        | `$SUDO systemctl enable --now`      | Enable and start unit(s)                                         |
| `sc-disable-now`       | `$SUDO systemctl disable --now`     | Disable and stop unit(s)                                         |
| `sc-mask-now`          | `$SUDO systemctl mask --now`        | Mask and stop unit(s)                                            |

### Privileged aliases

systemd plugin supports multiple privilege elevation tools. When evaluating aliases `$SUDO`
(`$privilege_tool` in code) gets expanded to the relevant command.

You can choose which tool to use by setting `$ZSH_THEME_SYSTEMD_PRIVILEGE_TOOL`. The
default, which is used when the variable is not set (or set incorrectrly) is `sudo`.

Available options are:

| Tool             | Command   | Comment                                                                                 | 
|:-----------------|:----------|:----------------------------------------------------------------------------------------|
| `builtin-polkit` | --        | Does no prepend any command, leaving authorization to systemd                           | 
| `custom`         | varies    | Sets `$privilege_tool` to the value of `$ZSH_THEME_SYSTEMD_PRIVILEGE_TOOL_CUSTOM`       |
| `sudo`           | `sudo`    | Default value                                                                           |
| `sudo-rs`        | `sudo-rs` | Memory safe implementation of sudo                                                      | 
| `doas`           | `doas`    | Fork of OpenBSD `doas` command                                                          |
| `pkexec`         | `pkexec`  | Uses polkit for authorization                                                           |
| `run0`           | `run0`    | Part of systemd, does not rely on suid. Uses the same polkit action as `builtin-polkit` | 

### User aliases

You can use the above aliases as `--user` by using the prefix `scu` instead of `sc`.
For example: `scu-list-units` will be aliased to `systemctl --user list-units`.

### Unit Status Prompt

You can add a token to your prompt in a similar way to the gitfast plugin. To add the token
to your prompt, drop `$(systemd_prompt_info [unit]...)` into your prompt (more than one unit
may be specified).

The plugin will add the following to your prompt for each `$unit`.

```text
<prefix><unit>:<active|notactive><suffix>
```

You can control these parts with the following variables:

- `<prefix>`: Set `$ZSH_THEME_SYSTEMD_PROMPT_PREFIX`.

- `<suffix>`: Set `$ZSH_THEME_SYSTEMD_PROMPT_SUFFIX`.

- `<unit>`: name passed as parameter to the function. If you want it to be in ALL CAPS,
  you can set the variable `$ZSH_THEME_SYSTEMD_PROMPT_CAPS` to a non-empty string.

- `<active>`: shown if the systemd unit is active.
  Set `$ZSH_THEME_SYSTEMD_PROMPT_ACTIVE`.

- `<notactive>`: shown if the systemd unit is *not* active.
  Set `$ZSH_THEME_SYSTEMD_PROMPT_NOTACTIVE`.

For example, if your prompt contains `PROMPT='$(systemd_prompt_info dhcpd httpd)'` and you set the following variables:

```sh
ZSH_THEME_SYSTEMD_PROMPT_PREFIX="["
ZSH_THEME_SYSTEMD_PROMPT_SUFFIX="]"
ZSH_THEME_SYSTEMD_PROMPT_ACTIVE="+"
ZSH_THEME_SYSTEMD_PROMPT_NOTACTIVE="X"
ZSH_THEME_SYSTEMD_PROMPT_CAPS=1
```

If `dhcpd` is running, and `httpd` is not, then your prompt will look like this:

```text
[DHCPD: +][HTTPD: X]
```
