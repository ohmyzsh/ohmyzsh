# pitchfork

Adds integration with [pitchfork](https://github.com/jdx/pitchfork), a devilishly good process manager for
developers. Pitchfork manages background daemons and services for local development environments, automatically
starting and stopping them as you navigate between project directories.

## Installation

1. [Download & install pitchfork](https://github.com/jdx/pitchfork#installation) by running the following:

```bash
mise use -g pitchfork
```

Or install via Cargo:

```bash
cargo install pitchfork-cli
```

2. [Enable pitchfork](https://pitchfork.jdx.dev) by adding it to your `plugins` definition in `~/.zshrc`.

```bash
plugins=(pitchfork)
```

## Usage

See the [pitchfork docs](https://pitchfork.jdx.dev) for full information. Here are a few examples:

```bash
pitchfork start --all     Start all configured daemons
pitchfork stop            Stop running daemons
pitchfork status          Show status of all daemons
pitchfork logs [name]     View logs for a daemon
pitchfork tui             Open the terminal dashboard
```

The plugin loads pitchfork's shell hook (`pitchfork activate zsh`), which automatically starts and stops
daemons when you enter or leave a project directory, and sets up zsh tab-completions.
