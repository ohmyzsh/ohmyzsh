# brew plugin

The plugin adds several aliases for common [brew](https://brew.sh) commands.

To use it, add `brew` to the plugins array of your zshrc file:

```zsh
plugins=(... brew)
```

## Shellenv

If `brew` is not found in the PATH, this plugin will attempt to find it in common locations, and execute
`brew shellenv` to set the environment appropriately. This plugin will also export
`HOMEBREW_PREFIX="$(brew --prefix)"` if not previously defined for convenience.

In case you installed `brew` in a non-common location, you can still set `BREW_LOCATION` variable pointing to
the `brew` binary before sourcing `oh-my-zsh.sh` and it'll set up the environment.

## Aliases

| Alias    | Command                                 | Description                                                           |
| -------- | --------------------------------------- | --------------------------------------------------------------------- |
| `ba`     | `brew autoremove`                       | Uninstall unnecessary formulae.                                       |
| `bci`    | `brew info --cask`                      | Display information about the given cask.                             |
| `bcin`   | `brew install --cask`                   | Install the given cask.                                               |
| `bcl`    | `brew list --cask`                      | List installed casks.                                                 |
| `bcn`    | `brew cleanup`                          | Run cleanup.                                                          |
| `bco`    | `brew outdated --cask`                  | Report all outdated casks.                                            |
| `bcrin`  | `brew reinstall --cask`                 | Reinstall the given cask.                                             |
| `bcubc`  | `brew upgrade --cask && brew cleanup`   | Upgrade outdated casks, then run cleanup.                             |
| `bcubo`  | `brew update && brew outdated --cask`   | Update Homebrew data, then list outdated casks.                       |
| `bcup`   | `brew upgrade --cask`                   | Upgrade all outdated casks.                                           |
| `bfu`    | `brew upgrade --formula`                | Upgrade only formulae (not casks).                                    |
| `bi`     | `brew install`                          | Install a formula.                                                    |
| `bl`     | `brew list`                             | List all installed formulae.                                          |
| `bo`     | `brew outdated`                         | List installed formulae that have an updated version available.       |
| `brewp`  | `brew pin`                              | Pin a specified formula so that it's not upgraded.                    |
| `brews`  | `brew list -1`                          | List installed formulae or the installed files for a given formula.   |
| `brewsp` | `brew list --pinned`                    | List pinned formulae, or show the version of a given formula.         |
| `bsl`    | `brew services list`                    | List all running services.                                            |
| `bsoff`  | `brew services stop`                    | Stop the service and unregister it from launching at login (or boot). |
| `bsoffa` | `bsoff --all`                           | Stop all started services.                                            |
| `bson`   | `brew services start`                   | Start the service and register it to launch at login (or boot).       |
| `bsona`  | `bson --all`                            | Start all stopped services.                                           |
| `bsr`    | `brew services run`                     | Run the service without registering to launch at login (or boot).     |
| `bsra`   | `bsr --all`                             | Run all stopped services.                                             |
| `bu`     | `brew update`                           | Update brew and all installed formulae.                               |
| `bubo`   | `brew update && brew outdated`          | Update Homebrew data, then list outdated formulae and casks.          |
| `bubu`   | `bubo && bup`                           | Do the last two operations above.                                     |
| `bugbc`  | `brew upgrade --greedy && brew cleanup` | Upgrade outdated formulae and casks (greedy), then run cleanup.       |
| `bup`    | `brew upgrade`                          | Upgrade outdated, unpinned brews.                                     |
| `buz`    | `brew uninstall --zap`                  | Remove all files associated with a cask.                              |

## Completion

This plugin configures paths with Homebrew's completion functions automatically, so you don't need to do it
manually. See: https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh.

With the release of Homebrew 1.0, they decided to bundle the zsh completion as part of the brew installation,
so we no longer ship it with the brew plugin; now it only has brew aliases. If you find that brew completion
no longer works, make sure you have your Homebrew installation fully up to date.
