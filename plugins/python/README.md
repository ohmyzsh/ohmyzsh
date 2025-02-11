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
| `pyfind`         | Finds .py files recursively in the current directory                                   |
| `pyclean [dirs]` | Deletes byte-code and cache files from a list of directories or the current one        |
| `pygrep <text>`  | Looks for `text` in `*.py` files in the current directory, recursively                 |
| `pyuserpaths`    | Add user site-packages folders to `PYTHONPATH`, for Python 2 and 3                     |
| `pyserver`       | Starts an HTTP server on the current directory (use `--directory` for a different one) |

## Virtual environments

The plugin provides three utilities to manage Python 3.3+ [venv](https://docs.python.org/3/library/venv.html)
virtual environments:

- `mkv [name]`: make a new virtual environment called `name` in the current directory.
  **Default**: `$PYTHON_VENV_NAME` if set, otherwise `venv`.

- `vrun [name]`: activate the virtual environment called `name` in the current directory.
  **Default**: the first existing in `$PYTHON_VENV_NAMES`.

- `auto_vrun`: automatically activate the venv virtual environment when entering a directory containing
  `<venv-name>/bin/activate`, and automatically deactivate it when navigating out of it (keeps venv activated
  in subdirectories).
  - To enable the feature, set `PYTHON_AUTO_VRUN=true` before sourcing oh-my-zsh.
  - The plugin activates the first existing virtual environment, in order, appearing in `$PYTON_VENV_NAMES`.
    The default virtual environment name is `venv`. To use a different name, set
    `PYTHON_VENV_NAME=<venv-name>`. For example: `PYTHON_VENV_NAME=".venv"`

### Settings

You can set these variables in your `.zshrc` file, before Oh My Zsh is sourced.
For example:

```sh
PYTHON_VENV_NAME=".venv"
PYTHON_VENV_NAMES=($PYTHON_VENV_NAME venv)
...
plugins=(... python)
source "$ZSH/oh-my-zsh.sh"
```


## `$PYTHON_VENV_NAME`

**Default**: `venv`.

Preferred name for virtual environments, for example when creating via `mkv`.

## `$PYTHON_VENV_NAMES`

**Default**: `$PYTHON_VENV_NAME venv .venv`.

Array of virtual environment names to be checked, in order, by `vrun` and `auto_vrun`.
This means these functions will load the first existing virtual environment in this list.
Duplicate names are ignored.

