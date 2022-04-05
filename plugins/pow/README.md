# pow plugin

This plugin adds completion and commands for [pow](http://pow.cx/), a
zero-configuration Rack server for macOS.

To use it, add pow to the plugins array of your zshrc file:

```sh
plugins=(... pow)
```

## Commands

- `kapow` will restart an app.

  ```bash
  kapow myapp
  ```

- `kaput` will show the standard output from any pow app.
- `repow` will restart the pow process.
