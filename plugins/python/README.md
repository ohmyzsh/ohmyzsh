# python plugin

The plugin adds several aliases for common [python](https://www.python.org/) commands.

To use it, add `python` to the plugins array of your zshrc file:
```
plugins=(... python)
```

## Aliases

| Alias    | Command                 | Description   |
|----------|-------------------------|---------------|
| pyfind   | `pyfind filename`       | Finds the given python file in the current directory |
| pyclean  | `pyclean directory_list`| Remove python compiled byte-code and mypy cache from the current directory or in a list of directories|
| pygrep   | `pygrep text`           | Greps the given text from all the python files in the current directory |
