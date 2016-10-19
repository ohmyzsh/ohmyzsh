# cask plugin

Loads `cask` completion from non-standard locations, such as if installed
via Homebrew or others. To enable it, add `cask` to your plugins array:

```zsh
plugins=(... cask)
```

Make sure you have the `cask` directory in your `$PATH` before loading
Oh My Zsh, otherwise you'll get the "command not found" error.
