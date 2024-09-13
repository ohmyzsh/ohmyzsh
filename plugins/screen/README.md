# screen

This plugin sets title and hardstatus of the tab window for [screen](https://www.gnu.org/software/screen/),
the terminal multiplexer.

To use it add `screen` to the plugins array in your zshrc file.

```zsh
plugins=(... screen)
```
# Plugin commands
- `sls` runs `screen -ls` to list active screen sessions.
- `sr` runs `screen -r` to reconnect to a detached session.
- `ss <session_name>` runs `session -S <session_name>` to start a session.
