# TextMate plugin

The plugin adds a function for the [TextMate](https://macromates.com) editor.

To use it, add `textmate` to the plugins array of your zshrc file:
```
plugins=(... textmate)
```

## Function

The `tm` function provides the following options:

- No arguments: Run `mate` in the current directory.
- Argument that is a directory: Run `mate` in the given directory and cd to it.
- Other arguments: Pass all arguments to `mate`. This allows for easy opening of multiple files.
