## asdf

Adds integration with [asdf](https://github.com/asdf-vm/asdf), the extendable version manager, with support for Ruby, Node.js, Elixir, Erlang and more.

### Installation

1. [Download asdf](https://asdf-vm.com/guide/getting-started.html#_1-install-asdf):

  ```sh
  # For macos via homebrew
  brew install asdf
```

For OS's where asdf isn't directly available to download via the package manager, follow [this](https://asdf-vm.com/guide/getting-started.html#install-asdf) section.

2. [Enable asdf](https://asdf-vm.com/guide/getting-started.html#_3-install-asdf) by adding it to your `plugins` definition in `~/.zshrc`.

  ```sh
  plugins=(asdf)
  ```

### Usage

See the [asdf plugin documentation](https://asdf-vm.com/guide/getting-started.html#_4-install-a-plugin) for information on how to use asdf:

```sh
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs latest

# Set the latest version
asdf set nodejs latest

# Set globally to a pinned version 
asdf set -u nodejs 16.5.0
```

### Maintainer

- [@RobLoach](https://github.com/RobLoach)
