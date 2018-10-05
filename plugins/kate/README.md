# Kate plugin

This plugin adds aliases for the [Kate editor](https://kate-editor.org).

To use it, add kate to the plugins array of your zshrc file:
```
plugins=(... kate)
```

## Aliases

| Alias | Command                | Description         |
|-------|------------------------|---------------------|
| kate  | `kate >/dev/null 2>&1` | Start kate silently |

## Functions

| Function   | Description                              |
|------------|------------------------------------------|
| `kt <dir>` | Change to directory and start kate there |
