# 🐳 dockolor – Colorized `docker ps` Output

**dockolor** is a lightweight plugin that enhances your `docker ps` experience with color-coded output based on container status. It also replaces common aliases like `dps` and `dpsa` if defined.

## Features

- Colors container statuses:
  - 🟢 **Up / Running** — Green
  - 🟡 **Paused** — Yellow
  - 🔴 **Exited / Dead** — Red
- Preserves the original Docker `ps` output, just adds color.
- Replaces `dps` and `dpsa` aliases (from the `docker` plugin) with colored versions.
- Falls back gracefully if `awk` is not installed.

## Installation

### Oh My Zsh

Simply add `dockolor` in you plugin list

```
plugins=(... dockolor)
```

Reload your shell:

```
source ~/.zshrc
```

### Any other way

- Copy or clone the `dockolor.plugin.zsh` file
- Source it in your `.zshrc` or `.bashrc`
- Use the `dockolor` command in place of the `docker ps` command
- You can also add an alias, something like:

```
myalias() {
  dockolor "$@"
}
```

Reload your shell:

```
source ~/.zshrc
```

## Usage

- `dockolor` — Same as `docker ps`, but colorized.
- `dps` — Replaced with `dockolor_dps`, same as `dockolor` or `docker ps`.
- `dpsa` — Replaced with `dockolor_dps -a`, same as `dockolor -a` or `docker ps -a`.

