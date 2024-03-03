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

The plugin provides three utilities to manage Python 3.3+
[venv](https://docs.python.org/3/library/venv.html) virtual
environments:

- `mkv [name]`: make a new virtual environment called `name` (default: `venv`) in current directory.

- `vrun [name]`: activate virtual environment called `name` (default: `venv`) in current directory.

- `auto_vrun`: Automatically activate the venv virtual environment when
  cd’ing into a directory containing `venv/bin/activate`, and
  automatically deactivate it when cd’ing into any other directory,
  including subdirectories.
  - To enable, set `PYTHON_AUTO_VRUN` to anything. For example:

        export PYTHON_AUTO_VRUN='true'
  - To disable, either unset the environment variable:

        unset PYTHON_AUTO_VRUN
    or entirely remove `auto_vrun` from the list of functions associated
    with the `chpwd` hook:

        add-zsh-hook -d chpwd auto_vrun
    If you disable `auto_vrun` while a virtual environment is active,
    you'll need to manually `deactivate`.
  - The default virtual environment name is "venv". To use a different
    name, set `PYTHON_VENV_NAME`. For example:

        export PYTHON_VENV_NAME='.venv'
