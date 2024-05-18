# tldr plugin

This plugin adds a shortcut to insert tldr before the previous command.
Heavily inspired from [Man plugin](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/man).

To use it, add `tldr` to the plugins array in your zshrc file:

```zsh
plugins=(... tldr)
```

# Keyboard Shortcuts
| Shortcut                           | Description                                                                |
|------------------------------------|----------------------------------------------------------------------------|
| <kbd>Esc</kbd> + tldr              | add tldr before the previous command to see the tldr page for this command |
