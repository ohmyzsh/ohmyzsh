# last-working-dir plugin

Keeps track of the last used working directory and automatically jumps into it
for new shells, unless:

- The plugin is already loaded.
- The current `$PWD` is not `$HOME`.

Also adds `lwd` function to jump to the last working directory.

To use it, add `last-working-dir` to the plugins array in your zshrc file:

```zsh
plugins=(... last-working-dir)
```
