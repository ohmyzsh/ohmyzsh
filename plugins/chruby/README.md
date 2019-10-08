# chruby plugin

This plugin loads the [chruby](https://github.com/postmodern/chruby). Supports brew and manual installation of chruby.

To use it, add `chruby` to the plugins array in your zshrc file:

```zsh
plugins=(... chruby)
```

## Usage

If you'd prefer to specify an explicit path to load chruby from
you can set variables like so:

```
zstyle :omz:plugins:chruby path /local/path/to/chruby.sh
zstyle :omz:plugins:chruby auto /local/path/to/auto.sh
```
