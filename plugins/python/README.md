# Python plugin

The plugin adds several aliases for useful [Python](https://www.python.org/) commands.

To use it, add `python` to the plugins array in your zshrc file:

```zsh
plugins=(... python)
```

## Aliases

| Command          | Description                                                                            |
| ---------------- | -------------------------------------------------------------------------------------- |
| `py`             | Runs `python3`. Only set if `py` is not installed.                                     |
| `ipython`        | Runs the appropriate `ipython` version according to the activated virtualenv           |
| `pyfind`         | Finds .py files recursively in the current directory                                   |
| `pyclean [dirs]` | Deletes byte-code and cache files from a list of directories or the current one        |
| `pygrep <text>`  | Looks for `text` in `*.py` files in the current directory, recursively                 |
| `pyuserpaths`    | Add user site-packages folders to `PYTHONPATH`, for Python 2 and 3                     |
| `pyserver`       | Starts an HTTP server on the current directory (use `--directory` for a different one) |

## Virtual environments

The plugin provides two utilities to manage Python venvs:

- `mkv [name]`: make a new virtual environment called `name` (default: `venv`) in current directory.

- `vrun [name]`: activate virtual environment called `name` (default: `venv`) in current directory.
