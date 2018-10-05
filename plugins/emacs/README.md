# Emacs plugin

This plugin utilizes the Emacs daemon capability, allowing the user to quickly open frames, whether they are opened in a terminal via a ssh connection, or X frames opened on the same host. The plugin also provides some aliases for such operations.

- You don't have the cost of starting Emacs all the time anymore
- Opening a file is as fast as Emacs does not have anything else to do.
- You can share opened buffered across opened frames.
- Configuration changes made at runtime are applied to all frames.

To use it, add emacs to the plugins array in your zshrc file:

```zsh
plugins=(... emacs)
```

## Aliases

The plugin utilizes this variable to call the emacs launcher:

```zsh
EMACS_PLUGIN_LAUNCHER="$ZSH/plugins/emacs/emacsclient.sh"
```

| Alias  | Command                                              | Description                                                                         |
|--------|------------------------------------------------------|-------------------------------------------------------------------------------------|
| emacs  | `"$EMACS_PLUGIN_LAUNCHER --no-wait"`                 | Opens a temporary emacsclient frame                                                 |
| e      | `emacs`                                              | Same as emacs alias                                                                 |
| te     | `"$EMACS_PLUGIN_LAUNCHER -nw"`                       | Open terminal emacsclient                                                           |
| eeval  | `"$EMACS_PLUGIN_LAUNCHER --eval"`                    | Same as `M-x eval` but from outside Emacs                                           |
| eframe | `'emacsclient --alternate-editor "" --create-frame'` | Create new X frame                                                                  |
|        | efile                                                | Write to standard output the path to the file opened in the current buffer          |
|        | ecd                                                  | Write to standard output the directory of the file opened in the the current buffer |
