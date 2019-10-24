# last-working-dir plugin

Keeps track of the last used working directory and automatically jumps into it
for new shells, unless:

- The plugin is already loaded.
- The current `$PWD` is not `$HOME`.

Adds `lwd` function to jump to the last working directory.
