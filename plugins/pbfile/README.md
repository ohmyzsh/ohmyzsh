# pbfile plugin

Copies files to the macOS pasteboard for pasting with Cmd+V in Finder, messengers, and other apps.

To use it, add `pbfile` to the plugins array in your zshrc file:

```zsh
plugins=(... pbfile)
```

## Usage

- `pbfile <file>`: copies the given file to the pasteboard for pasting as an attachment.

## Examples

```zsh
pbfile document.pdf
pbfile config.json
```
