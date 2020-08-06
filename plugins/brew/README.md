# brew plugin

The plugin adds several aliases for common [brew](https://brew.sh) commands.

To use it, add `brew` to the plugins array of your zshrc file:

```zsh
plugins=(... brew)
```

## Aliases

| Alias    | Command                                                     | Description                                                         |
|----------|-------------------------------------------------------------|---------------------------------------------------------------------|
| `brewp`  | `brew pin`                                                  | Pin a specified formula so that it's not upgraded.                  |
| `brews`  | `brew list -1`                                              | List installed formulae or the installed files for a given formula. |
| `brewsp` | `brew list --pinned`                                        | List pinned formulae, or show the version of a given formula.       |
| `bubo`   | `brew update && brew outdated`                              | Update Homebrew and all formulae, then list outdated formulae.      |
| `bubc`   | `brew upgrade && brew cleanup`                              | Upgrade outdated formulae, then run cleanup.                        |
| `bubu`   | `bubo && bubc`                                              | Do the last two operations above.                                   |
| `bcubo`  | `brew update && brew cask outdated`                         | Update Homebrew and alll formulae, then list outdated casks.        |
| `bcubc`  | `brew cask reinstall $(brew cask outdated) && brew cleanup` | Update outdated casks, then run cleanup.                            |

## Completion

With the release of Homebrew 1.0, they decided to bundle the zsh completion as part of the
brew installation, so we no longer ship it with the brew plugin; now it only has brew
aliases. If you find that brew completion no longer works, make sure you have your Homebrew
installation fully up to date.
