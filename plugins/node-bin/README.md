# nodenv plugin

This plugin adds `node_modules/.bin` to your path. It does so recursively up the ancestor tree,
meaning it also  works for subdirectories and monorepos.

To use it, add `node-bin` to the plugins array in your zshrc file:

```zsh
plugins=(... node-bin)
```
