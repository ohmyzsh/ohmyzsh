# tmux

This plugin provides aliases for [tmux](https://tmux.github.io/), the terminal multiplexer. To use it add
`tmux` to the plugins array in your zshrc file.

```zsh
plugins=(... tmux)
```

The plugin also supports the following:

- determines if tmux is installed or not, if not, prompts user to install tmux
- determines if the terminal supports the 256 colors or not, sets the appropriate configuration variable
- sets the correct local config file to use

## Aliases

| Alias      | Command                    | Description                                              |
| ---------- | -------------------------- | -------------------------------------------------------- |
| `ta`       | tmux attach -t             | Attach new tmux session to already running named session |
| `tad`      | tmux attach -d -t          | Detach named tmux session                                |
| `tds`      | `_tmux_directory_session`  | Creates or attaches to a session for the current path    |
| `tkss`     | tmux kill-session -t       | Terminate named running tmux session                     |
| `tksv`     | tmux kill-server           | Terminate all running tmux sessions                      |
| `tl`       | tmux list-sessions         | Displays a list of running tmux sessions                 |
| `tmux`     | `_zsh_tmux_plugin_run`     | Start a new tmux session                                 |
| `tmuxconf` | `$EDITOR $ZSH_TMUX_CONFIG` | Open .tmux.conf file with an editor                      |
| `ts`       | tmux new-session -s        | Create a new named tmux session                          |

## Configuration Variables

| Variable                            | Description                                                                                                                    |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| `ZSH_TMUX_AUTOSTART`                | Automatically starts tmux (default: `false`)                                                                                   |
| `ZSH_TMUX_AUTOSTART_ONCE`           | Autostart only if tmux hasn't been started previously (default: `true`)                                                        |
| `ZSH_TMUX_AUTOCONNECT`              | Automatically connect to a previous session if it exits (default: `true`)                                                      |
| `ZSH_TMUX_AUTOQUIT`                 | Automatically closes terminal once tmux exits (default: `ZSH_TMUX_AUTOSTART`)                                                  |
| `ZSH_TMUX_CONFIG`                   | Set the configuration path (default: `$HOME/.tmux.conf`, `$XDG_CONFIG_HOME/tmux/tmux.conf`)                                    |
| `ZSH_TMUX_DEFAULT_SESSION_NAME`     | Set tmux default session name when autostart is enabled                                                                        |
| `ZSH_TMUX_AUTONAME_SESSION`         | Automatically name new sessions based on the basename of `$PWD` (default: `false`)                                             |
| `ZSH_TMUX_DETACHED`                 | Set the detached mode (default: `false`)                                                                                       |
| `ZSH_TMUX_FIXTERM`                  | Sets `$TERM` to 256-color term or not based on current terminal support                                                        |
| `ZSH_TMUX_FIXTERM_WITHOUT_256COLOR` | `$TERM` to use for non 256-color terminals (default: `tmux` if available, `screen` otherwise)                                  |
| `ZSH_TMUX_FIXTERM_WITH_256COLOR`    | `$TERM` to use for 256-color terminals (default: `tmux-256color` if available, `screen-256color` otherwise)                    |
| `ZSH_TMUX_ITERM2`                   | Sets the `-CC` option for [iTerm2 tmux integration](https://iterm2.com/documentation-tmux-integration.html) (default: `false`) |
| `ZSH_TMUX_UNICODE`                  | Set `tmux -u` option to support unicode                                                                                        |
