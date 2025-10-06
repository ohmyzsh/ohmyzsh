# Pipenv

This plugin provides some features to simplify the use of [Pipenv](https://pipenv.pypa.io/) while working on ZSH.

In your `.zshrc` file, add `pipenv` to the plugins section

```
plugins=(... pipenv ...)
```

## Features

- Adds completion for pipenv
- Auto activates and deactivates pipenv shell
- Adds short aliases for common pipenv commands
  - `pch` is aliased to `pipenv check`
  - `pcl` is aliased to `pipenv clean`
  - `pgr` is aliased to `pipenv graph`
  - `pi` is aliased to `pipenv install`
  - `pidev` is aliased to `pipenv install --dev`
  - `pl` is aliased to `pipenv lock`
  - `po` is aliased to `pipenv open`
  - `prun` is aliased to `pipenv run`
  - `psh` is aliased to `pipenv shell`
  - `psy` is aliased to `pipenv sync`
  - `pu` is aliased to `pipenv uninstall`
  - `pupd` is aliased to `pipenv update`
  - `pwh` is aliased to `pipenv --where`
  - `pvenv` is aliased to `pipenv --venv`
  - `ppy` is aliased to `pipenv --py`

## Configuration

### Shell activation

If you want to disable the shell activation and deactivation feature, add the following style to your `.zshrc` before sourcing `oh-my-zsh.sh`:

```zsh
zstyle ':omz:plugins:pipenv' auto-shell no
```
