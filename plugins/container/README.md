# Container Plugin

This plugin provides autocompletion and aliases for Apple's [container](https://github.com/apple/container) tool - a tool for creating and running Linux containers using lightweight virtual machines on macOS with Apple silicon.

## Usage

To use this plugin, add `container` to the plugins array in your `~/.zshrc` file:

```bash
plugins=(... container)
```

## Requirements

- macOS 26 or later
- Apple silicon Mac
- [Apple container](https://github.com/apple/container) tool installed

## Aliases

### Core Commands
- `cb` → `container build`
- `ccr` → `container create`
- `cst` → `container start`
- `csp` → `container stop`
- `ck` → `container kill`
- `cdl` → `container delete`
- `crm` → `container delete`
- `cls` → `container list`
- `clsa` → `container list -a`
- `cex` → `container exec`
- `cexit` → `container exec -it`
- `clo` → `container logs`
- `clof` → `container logs -f`
- `cin` → `container inspect`
- `cr` → `container run`
- `crit` → `container run -it`
- `crd` → `container run -d`

### Image Management
- `cils` → `container image list`
- `cipl` → `container image pull`
- `cips` → `container image push`
- `cisv` → `container image save`
- `cild` → `container image load`
- `citg` → `container image tag`
- `cirm` → `container image delete`
- `cipr` → `container image prune`
- `ciin` → `container image inspect`

### Builder Management
- `cbst` → `container builder start`
- `cbsp` → `container builder stop`
- `cbss` → `container builder status`
- `cbrm` → `container builder delete`

### Network Management (macOS 26+)
- `cncr` → `container network create`
- `cnrm` → `container network delete`
- `cnls` → `container network list`
- `cnin` → `container network inspect`

### Volume Management
- `cvcr` → `container volume create`
- `cvrm` → `container volume delete`
- `cvls` → `container volume list`
- `cvin` → `container volume inspect`

### Registry Management
- `crli` → `container registry login`
- `crlo` → `container registry logout`

### System Management
- `csst` → `container system start`
- `cssp` → `container system stop`
- `csss` → `container system status`
- `cslo` → `container system logs`
- `cske` → `container system kernel set`
- `cspl` → `container system property list`
- `cspg` → `container system property get`
- `csps` → `container system property set`
- `cspc` → `container system property clear`

## Autocompletion

The plugin provides comprehensive autocompletion for:

- All container commands and subcommands
- Container IDs (running, stopped, or all)
- Image names and tags
- Network names
- Volume names
- Command-specific options and flags
- File paths for relevant commands

## Installation

If you're using Oh My Zsh with custom plugins:

1. Clone or copy this plugin to your custom plugins directory:
   ```bash
   cp -r container ~/.oh-my-zsh/custom/plugins/
   ```

2. Add `container` to your plugins list in `~/.zshrc`:
   ```bash
   plugins=(... container)
   ```

3. Restart your shell or run:
   ```bash
   source ~/.zshrc
   ```

## Contributing

This plugin is based on the official Apple container command reference. If you find any issues or missing completions, please report them or submit a pull request.

## License

This plugin is released under the same license as Oh My Zsh.