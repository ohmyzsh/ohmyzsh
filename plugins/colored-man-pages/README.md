# Colored man pages plugin

This plugin adds colors to man pages.

To use it, add `colored-man-pages` to the plugins array in your zshrc file:

```zsh
plugins=(... colored-man-pages)
```

It will also automatically colorize man pages displayed by `dman` or `debman`,
from [`debian-goodies`](https://packages.debian.org/stable/debian-goodies).

You can also try to color other pages by prefixing the respective command with `colored`:

```zsh
colored git help clone
```

## Customization

The plugin declares global associative array `less_termcap`, which maps termcap capabilities to escape sequences for the `less` pager. This mapping can be further customized by the user after the plugin is loaded. Check out sources for more.
