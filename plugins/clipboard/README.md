# clipboard plugin

This plugin integrates zsh kill-ring with system clipboard.

It makes it possible to kill in zsh and paste into browser/editor or vice versa.

Key bindings that rebound by the plugin are `C-y`, `C-k`, `C-u`, `M-d`, `M-backspace` and `M-w`.

The plugin should not change behaviour of these keys.

| Key binding | Description                                                |
|-------------|------------------------------------------------------------|
| CTRL+Y      | Yanks from the system clipboard into ZSH                   |
| CTRL+K      | Cuts rest of the line and puts it in the system clipboard  |
| CTRL+U      | Cuts the line and puts it in the system clipboard          |
| META+D      | Cuts the word forward and puts it in the system clipboard  |
| META+BSC    | Cuts the word backward and puts it in the system clipboard |
| META+W      | Copies region and puts it in the system clipboard          |
