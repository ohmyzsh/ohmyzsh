# brew plugin

The plugin adds several aliases for common [brew](https://brew.sh) commands.

To use it, add `brew` to the plugins array of your zshrc file:

```zsh
plugins=(... brew)
```

## Shellenv

If `brew` is not found in the PATH, this plugin will attempt to find it in common
locations, and execute `brew shellenv` to set the environment appropriately.
This plugin will also export `HOMEBREW_PREFIX="$(brew --prefix)"` if not previously
defined for convenience.

## Aliases

| Alias    | Command                                 | Description                                                         |
| -------- | --------------------------------------- | ------------------------------------------------------------------- |
| `bcubc`  | `brew upgrade --cask && brew cleanup`   | Update outdated casks, then run cleanup.                            |
| `bcubo`  | `brew update && brew outdated --cask`   | Update Homebrew data, then list outdated casks.                     |
| `brewp`  | `brew pin`                              | Pin a specified formula so that it's not upgraded.                  |
| `brews`  | `brew list -1`                          | List installed formulae or the installed files for a given formula. |
| `brewsp` | `brew list --pinned`                    | List pinned formulae, or show the version of a given formula.       |
| `bubc`   | `brew upgrade && brew cleanup`          | Upgrade outdated formulae and casks, then run cleanup.              |
| `bugbc`  | `brew upgrade --greedy && brew cleanup` | Upgrade outdated formulae and casks (greedy), then run cleanup.     |
| `bubo`   | `brew update && brew outdated`          | Update Homebrew data, then list outdated formulae and casks.        |
| `bubu`   | `bubo && bubc`                          | Do the last two operations above.                                   |
| `bfu`    | `brew upgrade --formula`                | Upgrade only formulas (not casks).                                  |
| `buz`    | `brew uninstall --zap`                  | Remove all files associated with a cask.                            |

## Completion

This plugin configures paths with Homebrew's completion functions automatically, so you don't need to do it manually. See: https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh.

With the release of Homebrew 1.0, they decided to bundle the zsh completion as part of the
brew installation, so we no longer ship it with the brew plugin; now it only has brew
aliases. If you find that brew completion no longer works, make sure you have your Homebrew
installation fully up to date.
