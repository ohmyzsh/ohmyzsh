# uv Environment Plugin

This plugin automatically activates the uv virtual environment when you cd into a project directory, and deactivates it when you cd out.
Note: Script looks for pyproject.toml and uv.lock files to determine if it's a uv project

To use it, add `uv-env` to the plugins array in your zshrc file:

```zsh
plugins=(... uv-env)
```
