# Dirpersist plugin

This plugin keeps a running tally of the previous 20 unique directories in the $HOME/.zdirs file.  When you cd to a new directory, it is prepended to the beginning of the file.

To use it, add `dirpersist` to the plugins array in your zshrc file:

```zsh
plugins=(... dirpersist)
```
