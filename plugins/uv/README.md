# uv plugin

This plugin automatically installs [uv](https://github.com/astral-sh/uv)'s completions for you, and keeps them up to date. It also adds convenient aliases for common usage.

To use it, add `uv` to the plugins array in your zshrc file:

```zsh
plugins=(... uv)
```

## Aliases

| Alias | Command                                                                 | Description                                                          |
|:----- |------------------------------------------------------------------------ |:-------------------------------------------------------------------- |
| uva   | `uv add`                                                                | Add packages to the project                                          |
| uvexp | `uv export --format requirements-txt --no-hashes --output-file requirements.txt --quiet` | Export the lock file to `requirements.txt`          |
| uvl   | `uv lock`                                                               | Lock the dependencies                                                |
| uvlr  | `uv lock --refresh`                                                     | Rebuild the lock file without upgrading dependencies                 |
| uvlu  | `uv lock --upgrade`                                                     | Lock the dependencies to the newest compatible versions              |
| uvp   | `uv pip`                                                                | Manage pip packages                                                  |
| uvpy  | `uv python`                                                             | Manage Python installs                                               |
| uvr   | `uv run`                                                                | Run commands within the project's environment                        |
| uvrm  | `uv remove`                                                             | Remove packages from the project                                     |
| uvs   | `uv sync`                                                               | Sync the environment with the lock file                              |
| uvsr  | `uv sync --refresh`                                                     | "Force" sync the environment with the lock file (ignore cache)       |
| uvsu  | `uv sync --upgrade`                                                     | Sync the environment, allowing upgrades and ignoring the lock file   |
| uvup  | `uv self update`                                                        | Update the UV tool to the latest version                             |
| uvv   | `uv venv`                                                               | Manage virtual environments                                          |
