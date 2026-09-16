# mise

Adds integration with [mise](https://github.com/jdx/mise) (formerly `rtx`), a runtime executor compatible with
npm, nodenv, pyenv, etc. mise is written in rust and is very fast. 20x-200x faster than asdf. With that being
said, mise is compatible with asdf plugins and .tool-versions files. It can be used as a drop-in replacement.

## Installation

1. [Download & install mise](https://github.com/jdx/mise#installation) by running the following:

```bash
curl https://mise.jdx.dev/install.sh | sh
```

2. [Enable mise](https://github.com/jdx/mise#quickstart) by adding it to your `plugins` definition in
   `~/.zshrc`.

```bash
plugins=(mise)
```

## Usage

See the [mise readme](https://github.com/jdx/mise#table-of-contents) for information on how to use mise. Here
are a few examples:

```bash
mise install node         Install the current version specified in .tool-versions/.mise.toml
mise use -g node@system   Use system node as global default
mise install node@20.0.0  Install a specific version number
mise use -g node@20       Use node-20.x as global default
```

## Setting

- `ZSH_MISE_AUTOEXPORT_VERSIONS`: if set to `true`, the plugin will register a `chpwd` hook to update environment variable to reflect the current configuration. The variables are constructed from the output of `mise -ls -c`, with the `MISE_TOOL_` prefix, and their value is set to the full version of the tool, e.g., `M̀ISE_TOOL_PYTHON=3.8.20``. This can be used when building prompts.
