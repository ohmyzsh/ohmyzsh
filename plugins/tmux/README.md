# tmux

This plugin provides aliases for [tmux](http://tmux.github.io/), the terminal multiplexer.
To use it add `tmux` to the plugins array in your zshrc file.

```zsh
plugins=(... tmux)
```
The plugin also supports the following - 
- determines if tmux is installed or not, if not, prompts user to install tmux
- determines if the terminal supports the 256 colors or not, sets the appropriate configuration variable
- sets the correct local config file to use

## Aliases

| Alias  | Command               | Description                                                                                                                     |
| ------ | ----------------------|---------------------------------------------------------- |
| `ta`   | tmux attach -t        | Attach new tmux session to already running named session  |
| `tad`  | tmux attach -d -t     | Detach named tmux session                                 |
| `ts`   | tmux new-session -s   | Create a new named tmux session                           |
| `tl`   | tmux list-sessions    | Displays a list of running tmux sessions                  |
| `tksv` | tmux kill-server      | Terminate all running tmux sessions                       |
| `tkss` | tmux kill-session -t  | Terminate named running tmux session                      |
| `tmux` | _zsh_tmux_plugin_run  | Start a new tmux session                                  |


## Configuration Variables

| Variable                             | Description                                                                                                                                |
| ------------------------------------ |------------------------------------------------------------------------------------------------------------------------------------------- |
| `ZSH_TMUX_AUTOSTART`                 | Automatically starts tmux, By default set to `false`                                                                                       |
| `ZSH_TMUX_AUTOSTART_ONCE`            | Automatically starts tmux, By default set to `true`, If set to `false`, tmux will attempt to autostart every time zsh configs are reloaded |                                                  |
| `ZSH_TMUX_AUTOCONNECT`               | Automatically connect to a previous session if it exits, By default set to `true`                                                          |
| `ZSH_TMUX_AUTOQUIT`                  | Automatically closes terminal once tmux exits, By default set to variable `ZSH_TMUX_AUTOSTART`                                             |
| `ZSH_TMUX_FIXTERM`                   | Set terminal to screen or screen-256color based on current terminal support                                                                |
| `ZSH_TMUX_ITERM2`                    | Sets the `-CC` option for iTerm2 tmux integration                                                                                          |
| `ZSH_TMUX_FIXTERM_WITHOUT_256COLOR`  | Term to use for non-256 color terminals, Set to `screen` by default                                                                        |
| `ZSH_TMUX_FIXTERM_WITH_256COLOR`     | Term to use for 256 color terminals, Set to `screen-256color` by default                                                                   |
