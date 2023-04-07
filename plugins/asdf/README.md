## asdf

**Maintainer:** [@RobLoach](https://github.com/RobLoach)

Adds integration with [asdf](https://github.com/asdf-vm/asdf), the extendable version manager, with support for Ruby, Node.js, Elixir, Erlang and more.

### Installation

1. [Download asdf](https://asdf-vm.com/guide/getting-started.html#_2-download-asdf) by running the following:

  ```
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf
  ```

2. [Enable asdf](https://asdf-vm.com/guide/getting-started.html#_3-install-asdf) by adding it to your `plugins` definition in `~/.zshrc`.

  ```
  plugins=(asdf)
  ```

### Usage

See the [asdf documentation](https://asdf-vm.com/guide/getting-started.html#_4-install-a-plugin) for information on how to use asdf:

```
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs latest
asdf global nodejs latest
asdf local nodejs latest
```
