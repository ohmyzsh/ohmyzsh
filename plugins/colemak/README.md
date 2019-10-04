# Colemak Plugin

This plugin remaps keys in `zsh`'s [`vi`-style navigation
mode](http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Keymaps) 
for a [Colemak](https://colemak.com/) keyboard layout.

## Usage

To use it, add it to the plugins array in your `~/.zshrc` file:

```
plugins=(... colemak)
```

You will also need to enable `vi` mode, so add another line to `~/.zshrc`:

```
bindkey -v
```

Then, reload your `zsh` configuration:

```
source ~/.zshrc
```

Hit the `<ESC>` key to activate `vicmd` (navigation) mode, and start navigating
`zsh` with your new keybindings!

## Contributors

* [Jim Hester](https://github.com/jimhester) (author)
* [Griffin J Rademacher](https://github.com/favorable-mutation) (README)
