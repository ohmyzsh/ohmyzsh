# fnox

Adds integration and shell completions for [fnox](https://github.com/jdx/fnox), a tool for provider-agnostic secret injection.
Supports either standalone activation or `mise` integration if installed.

## Installation

1. *Optional:* [Download & install mise](https://github.com/jdx/mise#installation) by running the following:

```bash
curl https://mise.jdx.dev/install.sh | sh
```

2. [Enable fnox](https://fnox.jdx.dev/guide/quick-start.html) by adding it to your `plugins` definition in `~/.zshrc`.

```bash
# standalone
plugins=(fnox)

# with mise integration
plugins=(mise fnox)
```

## Usage

See the [fnox documentation](https://github.com/jdx/fnox#table-of-contents) for information on how to use `fnox` [standalone](https://fnox.jdx.dev/guide/shell-integration.html) or with [`mise` integration](https://fnox.jdx.dev/guide/mise-integration.html).
