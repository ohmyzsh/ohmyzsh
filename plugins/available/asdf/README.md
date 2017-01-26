## asdf

**Maintainer:** [@RobLoach](https://github.com/RobLoach)

Adds integration with [asdf](https://github.com/asdf-vm/asdf), the extendable version manager, with support for Ruby, Node.js, Elixir, Erlang and more.

### Installation

1. Enable the plugin by adding it to your `plugins` definition in `~/.zshrc`.

  ```
  plugins=(asdf)
  ```

2. [Install asdf](https://github.com/asdf-vm/asdf#setup) by running the following:
  ```
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf
  ```

### Usage

See the [asdf usage documentation](https://github.com/asdf-vm/asdf#usage) for information on how to use asdf:

```
asdf plugin-add nodejs git@github.com:asdf-vm/asdf-nodejs.git
asdf install nodejs 5.9.1
```
