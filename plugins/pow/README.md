# pow plugin

This plugin adds completion and commands for [pow](http://pow.cx/).

To use it, add pow to the plugins array of your zshrc file:

```sh
plugins=(... pow)
```

## commands and aliases

- `kapow` will restart an app

    ```bash
    kapow myapp
    ```

- `kaput` will show the standard out from any pow app
- `repow` will restart the process

## command completion

If you are not already using completion you might need to enable it with

```bash
autoload -U compinit compinit
```
