# pyenv 

This plugin adds completion for [pyenv](https://github.com/pyenv/pyenv), a Simple Python version management system.

To use it, add `pyenv` to the plugins array in your zshrc file:

```zsh
plugins=(... pyenv)
```

## Aliases

| Alias        | Command              | Description                                                                                                              |
| -------------| -------------------- | -------------------------------------------------------------------------------------------------------------------------|
| pyenv_prompt_info | `system: $(python -V 2>&1 | cut -f 2 -d ' ')` | Displays the global Python version, which is defined via pyenv  |                                         |
