# Poetry Environment Plugin

This plugin automatically changes poetry environment when you cd into or out of the project directory.
Note: Script looks for pyproject.toml file to determine poetry if its a poetry environment

To use it, add `poetry-env` to the plugins array in your zshrc file:

```zsh
plugins=(... poetry-env)
```
