# Datadog plugin

This plugin adds completion and aliases for the [Datadog Agent](https://docs.datadoghq.com/agent/)
command-line interface: `datadog-agent` on Linux and macOS, and `agent.exe` on Windows.

To use it, add `datadog` to the plugins array in your `~/.zshrc` file:

```zsh
plugins=(... datadog)
```

## Requirements

- [Datadog Agent](https://docs.datadoghq.com/agent/) v6 or v7, on Linux, macOS, or Windows.
- On Windows, a zsh from MSYS2, Git for Windows, or Cygwin.

## Aliases

| Alias    | Command                     | Description                                               |
| -------- | --------------------------- | --------------------------------------------------------- |
| `ddog`   | `datadog-agent`             | Run any Agent subcommand                                  |
| `ddc`    | `datadog-agent check`       | Run the specified check                                   |
| `ddcc`   | `datadog-agent configcheck` | Print all configurations loaded and resolved by the Agent |
| `ddcfg`  | `datadog-agent config`      | Show or change the runtime configuration                  |
| `dddiag` | `datadog-agent diagnose`    | Run the connectivity and installation diagnosis           |
| `ddh`    | `datadog-agent health`      | Print the current Agent health                            |
| `ddhn`   | `datadog-agent hostname`    | Print the hostname that the Agent uses                    |
| `ddl`    | `datadog-agent stream-logs` | Stream the logs that the Agent processes                  |
| `dds`    | `datadog-agent status`      | Print the status of the Agent and its integrations        |
| `ddv`    | `datadog-agent version`     | Print the Agent version                                   |

This alias is only available on macOS and Windows:

| Alias   | Command                    | Description                                               |
| ------- | -------------------------- | --------------------------------------------------------- |
| `ddgui` | `datadog-agent launch-gui` | Open the Agent GUI (Datadog Agent Manager) in the browser |

The base alias is `ddog` and not `dd`, because `dd` is a standard Unix command. The diagnose alias is `dddiag`
and not `ddd`, because `ddd` is the GNU DDD debugger.

Usage example to troubleshoot an integration:

```zsh
ddc nginx      # run the nginx check once and print its metrics
dds            # make sure that the check shows under "Running Checks"
```

The plugin does not add an alias for `flare`, because a flare sends files from your host to Datadog Support.
Type the subcommand in full when you want to send one, for example `ddog flare 1234567`.

## Platform notes

- **Linux**: the Agent commands need root, so the aliases run `sudo datadog-agent`. If you are root, `sudo` is
  not added. `ddc` runs as the `dd-agent` user, with `sudo -u dd-agent -- datadog-agent check`, as the
  [Linux documentation](https://docs.datadoghq.com/agent/supported_platforms/linux/#commands) recommends. If
  `sudo` is not installed, the aliases run `datadog-agent` directly.
- **Windows**: the plugin finds `agent.exe` in `C:\Program Files\Datadog\Datadog Agent\bin`. The Agent
  commands need an elevated shell, so start your terminal with "Run as administrator".
- **macOS**: the plugin finds `datadog-agent` in `$PATH`, or else in `/opt/datadog-agent/bin/agent`. With a
  system-wide install (`/Library/LaunchDaemons/com.datadoghq.agent.plist`), the aliases run
  `sudo datadog-agent`, as the
  [macOS documentation](https://docs.datadoghq.com/agent/supported_platforms/osx/#commands) shows. With the
  older per-user install, the aliases run `datadog-agent` directly.
- **Other systems**: the aliases run `datadog-agent` directly, without `sudo`. The `ddgui` alias is not
  defined.

The plugin does not add aliases that start, stop, or restart the Agent service. On Linux (`systemctl`,
`service`) and macOS (`launchctl`), use the service manager. You can use the [`systemd` plugin](../systemd) on
Linux. On Windows, type the subcommand in full, for example `ddog restart-service`.

## Settings

- `ZSH_DATADOG_AGENT_BINARY`: path to the Agent binary. Set it before Oh My Zsh is sourced if you installed
  the Agent in a different location. For example:

  ```zsh
  ZSH_DATADOG_AGENT_BINARY="/d/Datadog/Datadog Agent/bin/agent.exe"
  ```

## Completion

If the `datadog-agent` command is in your `$PATH`, the plugin generates the completion from
`datadog-agent completion zsh`. The aliases also get this completion.
