# Paver

This plugin adds completion for the `paver` command-line tool of [Paver](https://pythonhosted.org/Paver/).

To use it, add `paver` to the plugins array of your zshrc file:
```zsh
plugins=(... paver)
```

The completion function creates a cache of paver tasks with the name `.paver_tasks`,
in the current working directory. It regenerates that cache when the `pavement.py`
changes.
