# alias-printer plugin

This plugin searches the defined aliases and outputs any command that matches 
the inputted alias. So that when presenting the audience understands the alias 
being executed.

To use it, add `alias-printer` to the `plugins` array of your zshrc file:
```
plugins=(... alias-printer)
```

## Usage
To see if there is an alias defined for the command, pass it as an argument to 
`alias-printer`. This can also run automatically before each command you 
input. See the options below

## Options

- Use `--on` to start run automatically before each command you input.
- Use `--off`to stop the automatically running execute before each command you
- input.

## Examples
```
$ gl
alias-printer: git pull
```

```
$ gl && grbm
alias-printer: git pull && git rebase $(git_main_branch)
```
