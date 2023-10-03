## rtx


Adds integration with [rtx](https://github.com/jdx/rtx), a runtime executor compatible with npm,  nodenv, pyenv, etc. rtx is written in rust and is very fast. 20x-200x faster than asdf. With that being said, rtx is compatible with asdf plugins and .tool-versions files. It can be used as a drop-in replacement.

### Installation

1. [Download & install rtx](https://github.com/jdx/rtx#installation) by running the following:

  ```
  curl https://rtx.pub/install.sh | sh
  ```


2. [Enable rtx](https://github.com/jdx/rtx#quickstart) by adding it to your `plugins` definition in `~/.zshrc`.

  ```
  plugins=(rtx)
  ```

### Usage

See the [rtx readme](https://github.com/jdx/rtx#table-of-contents) for information on how to use rtx. Here are a few examples:

```
rtx install node         Install the current version specified in .tool-versions/.rtx.toml
rtx use -g node@system   Use system node as global default
rtx install node@20.0.0  Install a specific version number
rtx use -g node@20       Use node-20.x as global default
```
