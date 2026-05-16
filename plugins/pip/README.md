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

| Alias    | Command                                                                           | Description                                   |
| :--------|:----------------------------------------------------------------------------------|:--------------------------------------------- |
| pipi     | `pip install`                                                                     | Install packages                              |
| pipig    | `pip install "git+https://github.com/user/repo.git"`                              | Install package from GitHub repository        |
| pipigb   | `pip install "git+https://github.com/user/repo.git@branch"`                       | Install package from GitHub branch            |
| pipigp   | `pip install "git+https://github.com/user/repo.git@refs/pull/PR_NUMBER/head"`     | Install package from GitHub pull request      |
| pipu     | `pip install --upgrade`                                                           | Upgrade packages                              |
| pipun    | `pip uninstall`                                                                   | Uninstall packages                            |
| pipgi    | `pip freeze \| grep`                                                              | Grep through installed packages               |
| piplo    | `pip list --outdated`                                                             | List outdated packages                        |
| pipreq   | `pip freeze > requirements.txt`                                                   | Create requirements file                      |
| pipir    | `pip install -r requirements.txt`                                                 | Install packages from `requirements.txt` file |
| pipupall | `pip list --outdated \| awk 'NR > 2 { print $1 }' \| xargs pip install --upgrade` | Update all installed packages                 |
| pipunall | `pip list --format freeze \| cut -d= -f1 \| xargs pip uninstall`                  | Uninstall all installed packages              |
