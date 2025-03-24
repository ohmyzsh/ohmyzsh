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

# Install the latest available nodejs runtime version
asdf install nodejs latest

# Install nodejs v16.5.0 runtime version
asdf install nodejs 16.5.0

# Set the latest version in .tools-version in the current working directory
asdf set nodejs latest

# Set a version globally that will apply to all directories under $HOME
asdf set -u nodejs 16.5.0
```

## Maintainer

- [@RobLoach](https://github.com/RobLoach)
