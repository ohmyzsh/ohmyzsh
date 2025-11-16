# Prek plugin

This plugin adds aliases for common commands of [prek](https://prek.j178.dev/).

**Prek** is a faster, Rust-based drop-in replacement for pre-commit that provides better performance and additional features like workspace support and improved user experience. It's approximately **10x faster** than pre-commit for hook installation and **~7x faster** for execution.

To use this plugin, add it to the plugins array in your zshrc file:

```zsh
plugins=(... prek)
```

## About Prek

Prek offers several advantages over pre-commit:

- **~10x faster** installation and ~7x faster execution
- **Single binary** - no Python or runtime dependencies required
- **Workspace support** - manage multiple projects with separate configs in monorepos
- **Better UX** - improved commands like `prek run --directory` and `prek run --last-commit`
- **Drop-in replacement** - uses the same `.pre-commit-config.yaml` configuration

## Aliases

### Main Command

| Alias | Command | Description |
| ----- | ------- | ----------- |
| `pk` | `prek` | The `prek` command |

### Installation & Setup

| Alias | Command | Description |
| ----- | ------- | ----------- |
| `pki` | `prek install` | Install the prek git hook |
| `pkii` | `prek install --install-hooks` | Install the git hook and hook environments in one command |
| `pkih` | `prek install-hooks` | Install hook environments for all hooks in config |

### Running Hooks

| Alias | Command | Description |
| ----- | ------- | ----------- |
| `pkr` | `prek run` | Run hooks on staged files |
| `pkra` | `prek run --all-files` | Run hooks on all files in the repository |
| `pkrf` | `prek run --files` | Run hooks on specific files |
| `pkrl` | `prek run --last-commit` | Run hooks on files changed in the last commit |
| `pkrd` | `prek run --directory` | Run hooks on files in a specific directory |

### Management

| Alias | Command | Description |
| ----- | ------- | ----------- |
| `pku` | `prek uninstall` | Uninstall the prek git hook |
| `pkl` | `prek list` | List all available hooks and their descriptions |

### Updates

| Alias | Command | Description |
| ----- | ------- | ----------- |
| `pkau` | `prek auto-update` | Auto-update config to the latest repo versions |
| `pksu` | `prek self update` | Update prek itself to the latest version |

### Configuration

| Alias | Command | Description |
| ----- | ------- | ----------- |
| `pkvc` | `prek validate-config` | Validate `.pre-commit-config.yaml` file |
| `pkvm` | `prek validate-manifest` | Validate `.pre-commit-hooks.yaml` file |
| `pksc` | `prek sample-config` | Produce a sample `.pre-commit-config.yaml` file |

### Cache Management

| Alias | Command | Description |
| ----- | ------- | ----------- |
| `pkcd` | `prek cache dir` | Show the location of the prek cache |
| `pkcgc` | `prek cache gc` | Clean unused cached repositories and environments |
| `pkcc` | `prek cache clean` | Remove all prek cached data |

## Usage Examples

```zsh
# Install prek hooks
pki

# Run hooks on all files
pkra

# Run hooks on files changed in the last commit
pkrl

# Run a specific hook
pkr ruff

# Run hooks on files in a specific directory
pkrd src/

# Update hooks to latest versions
pkau

# Clean up unused cache
pkcgc
```

## Installation

First, install prek itself:

```zsh
# Using uv (recommended)
uv tool install prek

# Using pip
pip install prek

# Using Homebrew
brew install prek
```

For more installation options, see the [prek installation guide](https://prek.j178.dev/installation/).
