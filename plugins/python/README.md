# Python plugin

The plugin adds several aliases for useful [Python](https://www.python.org/) commands.

## Usage

Add `python` to the plugins array in your `zshrc` file:

```zsh
plugins=(... python)
```

## Aliases

| Command          | Description                                                                                                         |
| ---------------- | ------------------------------------------------------------------------------------------------------------------- |
| `py`             | Runs `python`                                                                                                       |
| `ipython`        | Runs the appropriate `ipython` version according to the activated virtualenv                                        |
| `pyfind`         | Find `.py` files recursively in the current directory                                                               |
| `pyclean [dirs]` | Delete byte-code and cache files from a list file paths                                                             |
| `pygrep [text]`  | Looks for `text` in .py files                                                                                       |
| `pyuserpaths`    | Add `--user site-packages` to `$PYTHONPATH`, for all installed python versions.                                     |
| `pyserver`       | Create a basic webserver serving files relative to the current directory. Use `--directory` to specify a directory. |

## Virtual environments

The plugin provides two utilities to manage Python venvs:

| Command       | default | Description                                                        |
| ------------- | ------- | ------------------------------------------------------------------ |
| `mkv [name]`  | `venv`  | make a new virtual environment called `name` in current directory. |
| `vrun [name]` | `venv`  | activate virtual environment called `name` in current directory.   |
