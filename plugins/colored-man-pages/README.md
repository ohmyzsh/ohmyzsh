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
