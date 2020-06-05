# brew plugin

The plugin adds several aliases for common [brew](https://brew.sh) commands.

To use it, add `brew` to the plugins array of your zshrc file:

```zsh
plugins=(... brew)
```

## Aliases

| Alias   | Command                            | Description                                                                                                               |
|---------|------------------------------------|---------------------------------------------------------------------------------------------------------------------------|
| bc      | `brew cleanup`                     | Remove stale lock files and outdated downloads for all formulae and casks, and remove old versions of installed formulae. |
| bci     | `brew cask info`                   | Displays information about the given cask.                                                                                |
| bcl     | `brew cask list`                   | List installed casks.                                                                                                     |
| bco     | `brew cask outdated`               | Report all outdated casks.                                                                                                |
| bcu     | `brew cask upgrade`                | Updates all outdated casks                                                                                                |
| bl      | `brew list`                        | List all installed formulae.                                                                                              |
| bo      | `brew outdated`                    | List installed formulae that have an updated version available.                                                           |
| bu      | `brew update`                      | Update all installed formulae.                                                                                            |
| brewp   | `brew pin`                         | Pin a specified formula so that it's not upgraded.                                                                        |
| brews   | `bl -1`                            | List installed formulae or the installed files for a given formula.                                                       |
| brewsp  | `bl --pinned`                      | List pinned formulae, or show the version of a given formula.                                                             |
| bubo    | `bu && bo`                         | Update Homebrew and all formulae, then list outdated formulae.                                                            |
| bubc    | `brew upgrade && bc`               | Upgrade outdated formulae, then run cleanup.                                                                              |
| bubu    | `bubo && bubc`                     | Do the last two operations above.                                                                                         |
| bcubo   | `bu && bco`                        | Update Homebrew and all formulae, then list outdated casks.                                                               |
| bubobco | `bubo && bco`                      | Fetch the newest version of Homebrew and all formulae, then list outdated formulae and casks.                             |
| bcubc   | `brew cask reinstall $(bco) && bc` | Update outdated casks, then run cleanup.                                                                                  |

## Completion

With the release of Homebrew 1.0, they decided to bundle the zsh completion as part of the
brew installation, so we no longer ship it with the brew plugin; now it only has brew
aliases. If you find that brew completion no longer works, make sure you have your Homebrew
installation fully up to date.