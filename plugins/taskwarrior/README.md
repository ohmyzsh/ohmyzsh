# taskwarrior

This plugin adds smart tab completion for [TaskWarrior](https://taskwarrior.org/).
It uses the zsh tab completion script (`_task`) shipped with TaskWarrior for the
completion definitions.

To use it, add `taskwarrior` to the plugins array in your zshrc file:

```zsh
plugins=(... taskwarrior)
```

## Examples

Typing `task [TAB]` will give you a list of commands, `task 66[TAB]` shows a
list of available modifications for that task, etcetera.

The latest version pulled in from the official project is of January 1st, 2015.
