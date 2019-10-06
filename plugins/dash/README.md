# Dash plugin

This plugin adds command line functionality for [Dash](https://kapeli.com/dash),
an API Documentation Browser.

This plugin requires Dash to be installed to work.

To use it, add `dash` to the plugins array in your zshrc file:

```zsh
plugins=(... dash)
```

Make sure to source your rc file:
```
source ~/.zshrc
```

## Usage

Open and switch to the dash application.
```
dash
```

Query for something in dash app.
```
dash golang
```
