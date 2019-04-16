# alias-finder plugin

## Description
This plugin searches the defined aliases and outputs any that match the command inputted. This makes learning new aliases easier.

## Enabling
To use it, add `alias-finder` to the `plugins` array of your zshrc file:
```
plugins=(... alias-finder)
```

## Usage
To see if there is an alias defined for the command, pass it as an argument to `alias-finder`. This can also run automatically before each command you input - add `export ZSH_ALIAS_FINDER_AUTOMATIC=true` to your zshrc if you want this.

## Examples
```
$ alias-finder "git pull"
gl='git pull'
g=git
```
```
$ alias-finder "web_search google oh my zsh"
google='web_search google'
```
