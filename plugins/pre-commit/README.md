# Pre-commit plugin

This plugin adds aliases for common commands of [pre-commit](https://pre-commit.com/).

To use this plugin, add it to the plugins array in your zshrc file:

```zsh
plugins=(... pre-commit)
```

## Aliases

| Alias   | Command                                | Description                                            |
| ------- | -------------------------------------- | ------------------------------------------------------ |
| prc     | `pre-commit`                           | The `pre-commit` command                               |
| prcau   | `pre-commit autoupdate`                | Update hooks automatically                             |
| prcr    | `pre-commit run`                       | The `pre-commit run` command                           |
| prcra   | `pre-commit run --all-files`           | Run pre-commit hooks on all files                      |
| prcrf   | `pre-commit run --files`               | Run pre-commit hooks on a given list of files          |


## Auto install `pre-commit` hook

This plugin can auto install the defined pre-commit hooks from a `.pre-commit-config.yaml`, if it detects that file in your current working dir.

## Settings

#### ZSH_PRE_COMMIT_AUTO_INSTALL

Set `ZSH_PRE_COMMIT_AUTO_INSTALL` to control auto install.

- `prompt` (default) will prompt on a per-directory basis
- `off` will turn the feature off
- any other setting will auto install without prompting.

```zsh
# in ~/.zshrc, before Oh My Zsh is sourced:
ZSH_PRE_COMMIT_AUTO_INSTALL=prompt|off|anything_else_is_on
```

#### ZSH_PRE_COMMIT_CONFIG_FILE

The plugin will default to use `.pre-commit-config.yaml`.

You can override this with the variable `$ZSH_PRE_COMMIT_CONFIG_FILE`, like so:

```zsh
# in ~/.zshrc, before Oh My Zsh is sourced:
ZSH_PRE_COMMIT_CONFIG_FILE=.my-custom-pre-commit-config.yaml
```

#### ZSH_PRE_COMMIT_INSTALLED_LIST

The default behavior of the plugin is to prompt for installation. It will also remember it did so, which will be cached in a list to be defined by: `$ZSH_PRE_COMMIT_INSTALLED_LIST`.

The details for the three options are:
- **Y**es: install and write the current dir into the list.
- **A**sk again for this directory: don't do anything now.
- **N**ever ask again for this directory: don't install, but write the current dir into the list.

By default, this list will be here `${ZSH_CACHE_DIR:-$ZSH/cache}/pre-commit-installed.list"`, but you can set the filename of that list to whatever you want:

```zsh
# in ~/.zshrc, before Oh My Zsh is sourced:
ZSH_PRE_COMMIT_INSTALLED_LIST=/path/to/list
```
