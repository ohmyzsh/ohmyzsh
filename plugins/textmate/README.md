# TextMate plugin

The plugin adds aliases for the [TextMate](https://macromates.com) editor.

To use it, add `textmate` to the plugins array of your zshrc file:
```
plugins=(... textmate)
```

## Aliases

| Alias           | Command     | Description   |
|-----------------|-------------|---------------|
| tm              | `mate .`    | Open TextMate in the current directory. |
| tm \<directory> | `mate <directory>` `cd <directory>` | Open TextMate in the given directory and cd to it. |
| tm <*>          | `mate "$@"` | Pass all arguments to `mate`. This allows for easy opening of multiple files. |
