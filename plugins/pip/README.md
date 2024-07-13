# pip plugin

This plugin adds completion for [pip](https://pip.pypa.io/en/latest/),
the Python package manager.

To use it, add `pip` to the plugins array in your zshrc file:

```zsh
plugins=(... pip)
```

## pip cache

The pip plugin caches the names of available pip packages from the PyPI index.
To trigger the caching process, try to complete `pip install`,
or you can run `zsh-pip-cache-packages` directly.

To reset the cache, run `zsh-pip-clear-cache` and it will be rebuilt next
the next time you autocomplete `pip install`.

## Aliases

| Alias    | Description                                   |
| :------- | :-------------------------------------------- |
| pipi     | Install packages                              |
| pipig    | Install package from GitHub repository        |
| pipigb   | Install package from GitHub branch            |
| pipigp   | Install package from GitHub pull request      |
| pipu     | Upgrade packages                              |
| pipun    | Uninstall packages                            |
| pipgi    | Grep through installed packages               |
| piplo    | List outdated packages                        |
| pipreq   | Create requirements file                      |
| pipir    | Install packages from `requirements.txt` file |
| pipupall | Update all installed packages                 |
| pipunall | Uninstall all installed packages              |
