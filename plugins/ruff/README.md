# ruff plugin

This plugin automatically installs [ruff](https://github.com/astral-sh/ruff)'s completions for you,
and keeps them up to date. It also adds convenient aliases for common usage.

To use it, add `ruff` to the plugins array in your zshrc file:

```zsh
plugins=(... ruff)
```

## Aliases

| Alias | Command              | Description                                                  |
| :---- | -------------------- | :----------------------------------------------------------- |
| ruc   | `ruff check`         | Run Ruff linter on the given files or directories            |
| rucf  | `ruff check --fix`   | Run Ruff linter and fix auto-fixable issues                  |
| ruf   | `ruff format`        | Run the Ruff formatter on the given files or directories     |
| rufc  | `ruff format --check`| Check if files are already formatted without making changes  |
| rur   | `ruff rule`          | Explain a rule (or all rules)                                |
| rul   | `ruff linter`        | List all supported upstream linters                          |
| rucl  | `ruff clean`         | Clear any caches in the current directory and subdirectories |
| ruup  | `ruff self update`   | Update Ruff to the latest version                            |
