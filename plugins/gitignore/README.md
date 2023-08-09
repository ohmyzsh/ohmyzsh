# gitignore

This plugin enables you the use of [gitignore.io](https://www.toptal.com/developers/gitignore) from the command line. You need an active internet connection.

To use it, add `gitignore` to the plugins array in your zshrc file:

```zsh
plugins=(... gitignore)
```

## Plugin commands

* `gi list`: List all the currently supported gitignore.io templates.

* `gi [TEMPLATENAME]`: Show git-ignore output on the command line, e.g. `gi java` to exclude class and package files.

* `gi [TEMPLATENAME] >> .gitignore`: Appending programming language settings to your projects .gitignore.
