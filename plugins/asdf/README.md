# asdf

Adds integration with [asdf](https://github.com/asdf-vm/asdf), the extendable version manager, with support for Ruby, Node.js, Elixir, Erlang and more.

## Installation

1. [Install](https://asdf-vm.com/guide/getting-started.html#_1-install-asdf) asdf and ensure that's it's discoverable on `$PATH`;
2. Enable it by adding it to your `plugins` definition in `~/.zshrc`:

```sh
plugins=(asdf)
```

## Usage

Refer to the [asdf plugin documentation](https://asdf-vm.com/guide/getting-started.html#_4-install-a-plugin) for information on how to add a plugin and install the many runtime versions for it.

Example for installing the nodejs plugin and the many runtimes for it:

```sh
# Add plugin to asdf
asdf plugin add nodejs

# Install the latest available version
asdf install nodejs latest

# Uninstall the latest version
asdf uninstall nodejs latest

# Install a specific version
asdf install nodejs 16.5.0

# Set the latest version in .tool-versions of the `current directory`
asdf set nodejs latest

# Set a specific version in the `parent directory`
asdf set -p nodejs 16.5.0   # -p is shorthand for --parent

# Set a global version under `$HOME`
asdf set -u nodejs 16.5.0   # -u is shorthand for --home
```

For more commands, run `asdf help` or refer to the
[asdf CLI documentation](https://asdf-vm.com/manage/commands.html#all-commands).

## Maintainer

- [@RobLoach](https://github.com/RobLoach)
