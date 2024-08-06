# pyenv

This plugin looks for [pyenv](https://github.com/pyenv/pyenv), a Simple Python version
management system, and loads it if it's found. It also loads pyenv-virtualenv, a pyenv
plugin to manage virtualenv, if it's found. If a venv is found pyenv won't load.

To use it, add `pyenv` to the plugins array in your zshrc file:

```zsh
plugins=(... pyenv)
```

If you receive a `Found pyenv, but it is badly configured.` error on startup, you may need to ensure that `pyenv` is initialized before the oh-my-zsh pyenv plugin is loaded. This can be achieved by adding the following earlier in the `.zshrc` file than the `plugins=(...)` line:

```zsh
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
```

## Settings

- `ZSH_PYENV_QUIET`: if set to `true`, the plugin will not print any messages if it
  finds that `pyenv` is not properly configured.

- `ZSH_PYENV_VIRTUALENV`: if set to `false`, the plugin will not load pyenv-virtualenv
  when it finds it.

## Functions

- `pyenv_prompt_info`: displays the Python version in use by pyenv; or the global Python
  version, if pyenv wasn't found.
