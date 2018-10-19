# gitignore

This plugin enables you the use of gitignore.io from the command line. You need an active internet connection.

To use it, add `gitignore` to the plugins array in your zshrc file:

```zsh
plugins=(... gitignore)
```

## Plugin commands
* `gi list` List displays a list of all of the currently support gitignore.io templates.
* `gi [TEMPLATENAME]` Show output on the command line, e.g. `gi java` to exclude class and package files.
* `gi [TEMPLATENAME] >> .gitignore` Appending programming language settings to your projects .gitignore.
