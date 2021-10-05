# python plugin

The plugin adds several aliases for useful [python](https://www.python.org/) commands.

To use it, add `python` to the plugins array of your zshrc file:
```
plugins=(... python)
```

## Aliases

| Command          | Description                                                                     |
|------------------|---------------------------------------------------------------------------------|
| `py`             | Runs `python`                                                                   |
| `ipython`        | Runs the appropriate `ipython` version according to the activated virtualenv    |
| `pyfind`         | Finds .py files recursively in the current directory                            |
| `pyclean [dirs]` | Deletes byte-code and cache files from a list of directories or the current one |
| `pygrep <text>`  | Looks for `text` in .py files                                                   |
| `pyuserpaths`    | Add --user site-packages to PYTHONPATH, for all installed python versions.      |
