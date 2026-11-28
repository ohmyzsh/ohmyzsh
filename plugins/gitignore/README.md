# gitignore

This plugin enables you to use [gitignore.io](https://www.gitignore.io) from the command line. You need an active internet connection to fetch templates. The plugin uses the gitignore.io CDN endpoint to simplify access and improve reliability.

To use it, add `gitignore` to the plugins array in your zshrc file:

```zsh
plugins=(... gitignore)
```

## Plugin commands

* `gi list`: List all the currently supported gitignore.io templates.

* `gi [TEMPLATENAME]`: Show git-ignore output on the command line, e.g. `gi java` to exclude class and package files.

* `gi [TEMPLATENAME] >> .gitignore`: Append the template rules to your project's `.gitignore` file.
