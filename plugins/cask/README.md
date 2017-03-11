# Cask plugin

[Cask](https://github.com/cask/cask) is a project management tool for Emacs that helps
automate the package development cycle; development, dependencies, testing, building,
packaging and more.

This plugin loads `cask` completion from non-standard locations, such as if installed
via Homebrew or others. To enable it, add `cask` to your plugins array:

```zsh
plugins=(... cask)
```

Make sure you have the `cask` directory in your `$PATH` before loading Oh My Zsh,
otherwise you'll get a "command not found" error.
