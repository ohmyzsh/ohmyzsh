## Magic Enter plugin

This plugin makes your enter key magical, by binding commonly used commands to it.

To use it, add `magic-enter` to the plugins array in your zshrc file. You can set the
commands to be run in your .zshrc, before the line containing plugins. If no command
is specified in a git directory, `git status` is executed; in other directories, `ls`.

```zsh
# defaults
MAGIC_ENTER_GIT_COMMAND='git status -u .'
MAGIC_ENTER_OTHER_COMMAND='ls -lh .'

plugins=(... magic-enter)
```

**Maintainer:** [@dufferzafar](https://github.com/dufferzafar)
