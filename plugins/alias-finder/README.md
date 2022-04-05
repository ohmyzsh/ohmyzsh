# alias-finder plugin

This plugin searches the defined aliases and outputs any that match the command inputted. This makes learning new aliases easier.

To use it, add `alias-finder` to the `plugins` array of your zshrc file:
```
plugins=(... alias-finder)
```

## Usage
To see if there is an alias defined for the command, pass it as an argument to `alias-finder`. This can also run automatically before each command you input - add `ZSH_ALIAS_FINDER_AUTOMATIC=true` to your zshrc if you want this.

## Options

- Use `--longer` or `-l` to allow the aliases to be longer than the input (match aliases if they contain the input).
- Use `--exact` or `-e` to avoid matching aliases that are shorter than the input.

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
```
$ alias-finder "git commit -v"
gc="git commit -v"
g=git
```
```
$ alias-finder -e "git commit -v"
gc='git commit -v'
```
```
$ alias-finder -l "git commit -v"
gc='git commit -v'
'gc!'='git commit -v --amend'
gca='git commit -v -a'
'gca!'='git commit -v -a --amend'
'gcan!'='git commit -v -a --no-edit --amend'
'gcans!'='git commit -v -a -s --no-edit --amend'
'gcn!'='git commit -v --no-edit --amend'
```
