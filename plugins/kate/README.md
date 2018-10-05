# Kate plugin

This plugin adds alias for the [Kate editor](https://kate-editor.org).

To use it, add kate to the plugins array of your zshrc file:
```
plugins=(... kate)
```

## Aliases

| Alias | Command                                   | Description                                                 |
|-------|-------------------------------------------|-------------------------------------------------------------|
| kate  | `kate >/dev/null 2>&1`                 | Start kate always silent                                       |

## Functions
| Function       | Description                                                                        |
|----------------|------------------------------------------------------------------------------------|
| kt             | Change the directory that is given as parameter and start there kate               |
