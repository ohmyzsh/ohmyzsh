# pyenv 

This plugin looks for [pyenv](https://github.com/pyenv/pyenv), a Simple Python version
management system, and loads it if it's found. It also defines a prompt function to
display the Python version in use.

To use it, add `pyenv` to the plugins array in your zshrc file:

```zsh
plugins=(... pyenv)
```

## Functions

- `pyenv_prompt_info`: displays the Python version in use by pyenv; or the global Python
  version, if pyenv wasn't found.
