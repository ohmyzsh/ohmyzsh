# Poetry Environment Plugin

This plugin automatically activates a Poetry environment when you enter a
directory containing both `pyproject.toml` and `poetry.lock`. It keeps the
environment active in project subdirectories, switches to nested Poetry
projects, and deactivates it when you leave the project tree.

To use it, add `poetry-env` to the plugins array in your zshrc file:

```zsh
plugins=(... poetry-env)
```
