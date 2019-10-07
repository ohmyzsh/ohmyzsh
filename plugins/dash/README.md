# Dash plugin

This plugin adds command line functionality for [Dash](https://kapeli.com/dash),
an API Documentation Browser for macOS. This plugin requires Dash to be installed
to work.

To use it, add `dash` to the plugins array in your zshrc file:

```zsh
plugins=(... dash)
```

## Usage

- Open and switch to the dash application.
```
dash
```

- Query for something in dash app: `dash query`
```
dash golang 
```

- You can optionally provide a keyword: `dash [keyword:]query`
```
dash python:tuple
```
