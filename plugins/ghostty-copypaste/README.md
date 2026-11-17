# zsh-ghostty-copypaste

[ghostty](https://ghostty.org/) users, this `zsh` plugin allows you to copy / paste a text selected with the keyboard with `ctrl+shift+c` / `ctrl+shift+v`.

This is a complement to [zsh-shift-select](https://github.com/jirutka/zsh-shift-select), allowing to copy with `{ctrl+}shift+{left,right,up,down,home,end}`.

To use it, add `ghostty-copypaste` to the plugins array of your `.zshrc` file:

```
plugins=(... ghostty-copypaste)
```

## Principle

- `ghossty` allows to copy / paste a text selected with the mouse, but not with the keyboard, because this is an action devoted to a terminal (`zsh`) and not to a terminal emulator (`ghostty`).
- When no mouse selection is started, `ghostty` passes a Control Sequence Introducer `^[[99;6u` / `^[[118;6u` to `zsh`. The plugin binds these CSI to the correct copy / paste functions for X11 or Wayland.
- Be careful, `ghostty` can lose focus when copying and pasting because of `xclip` or `wl-copy`/`wl-paste` in the plugin. If you use it as a context terminal ("quake"), it is best not to close it when it loses focus.
