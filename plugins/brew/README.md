# brew plugin

The plugin adds several aliases for common [brew](https://brew.sh) commands.

To use it, add `brew` to the plugins array of your zshrc file:

```zsh
plugins=(... brew)
```

## Aliases

| Alias    | Command                               | Description                                                                               |
|----------|---------------------------------------|-------------------------------------------------------------------------------------------|
| `brewp`  | `brew pin`                            | Pin a specified formula so that it's not upgraded.                                        |
| `brews`  | `brew list -1`                        | List installed formulae or the installed files for a given formula.                       |
| `brewsp` | `brew list --pinned`                  | List pinned formulae, or show the version of a given formula.                             |
| `bubo`   | `brew update && brew outdated`        | Update Homebrew data, then list outdated formulae and casks.                              |
| `bubc`   | `brew upgrade && brew cleanup`        | Upgrade outdated formulae and casks, then run cleanup.                                    |
| `bubu`   | `bubo && bubc`                        | Do the last two operations above.                                                         |
| `buf`    | `brew upgrade --formula`              | Upgrade only formulas (not casks).                                                        |
| `bcubo`  | `brew update && brew outdated --cask` | Update Homebrew data, then list outdated casks.                                           |
| `bcubc`  | `brew upgrade --cask && brew cleanup` | Update outdated casks, then run cleanup.                                                  |
| `bsl`    | `brew services list`                  | List all running services for the current user (or root).                                 |
| `bsr`    | `brew services run`                   | Run the service formula without registering to launch at login (or boot).                 |
| `bson`   | `brew services start`                 | Start the service formula immediately and register it to launch at login (or boot).       |
| `bsoff`  | `brew services stop`                  | Stop the service formula immediately and unregister it from launching at login (or boot). |

## Completion

With the release of Homebrew 1.0, they decided to bundle the zsh completion as part of the
brew installation, so we no longer ship it with the brew plugin; now it only has brew
aliases. If you find that brew completion no longer works, make sure you have your Homebrew
installation fully up to date.
