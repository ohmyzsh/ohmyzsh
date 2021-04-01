# python plugin

The plugin adds several aliases for useful [python](https://www.python.org/) commands.

To use it, add `python` to the plugins array of your zshrc file:

```zsh
plugins=(... python)
```

## Aliases

<<<<<<< HEAD
| Command          | Description                                                                           |
| ---------------- | ------------------------------------------------------------------------------------- |
| `py`             | Runs `python`                                                                         |
| `ipython`        | Runs the appropriate `ipython` version according to the activated virtualenv          |
| `pyfind`         | Finds .py files recursively in the current directory                                  |
| `pyclean [dirs]` | Deletes byte-code and cache files from a list of directories or the current one       |
| `pygrep <text>`  | Looks for `text` in .py files                                                         |
| `pyuserpaths`    | Add --user site-packages to PYTHONPATH, for all installed python versions.            |
| `pyserver`       | Starts an http.server on the current directory. Use `--directory` for a different one |

## Virtual environments

The plugin provides two utilities to manage Python venvs:

- `mkv [name]`: make a new virtual environment called `name` (default: `venv`) in current directory.

- `vrun [name]`: activate virtual environment called `name` (default: `venv`) in current directory.
