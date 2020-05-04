# brew plugin

The plugin adds several aliases for common [brew](https://brew.sh) commands.

To use it, add `brew` to the plugins array of your zshrc file:
```
plugins=(... brew)
```

## Aliases

| Alias   | Command              | Description   |
|---------|----------------------|---------------|
| bc      | `brew cleanup`       | Remove stale lock files and outdated downloads for all formulae and casks, and remove old versions of installed formulae. |
| bci     | `brew cask info`     | Displays information about the given cask. |
| bcl     | `brew cask list`     | List installed casks. |
| bco     | `brew cask outdated` | Report all outdated casks. |
| bcu     | `brew cask upgrade`  | Updates all outdated casks |
| bl      | `brew list`          | List all installed formulae. |
| bo      | `brew outdated`      | List installed formulae that have an updated version available. |
| bu      | `brew update`        | Update all installed formulae. |
| brewp   | `brew pin`           | Pin a specified formulae, preventing them from being upgraded when issuing the brew upgrade <formulae> command. |
| brews   | `bl -1`       | List installed formulae, one entry per line, or the installed files for a given formulae. |
| brewsp  | `bl --pinned` | Show the versions of pinned formulae, or only the specified (pinned) formulae if formulae are given. |
| bubo    | `bu && bo` | Fetch the newest version of Homebrew and all formulae, then list outdated formulae. |
| bubc    | `brew upgrade && bc` | Upgrade outdated, unpinned brews (with existing install options), then removes stale lock files and outdated downloads for formulae and casks, and removes old versions of installed formulae. |
| bubu    | `bubo && bubc` | Updates Homebrew, lists outdated formulae, upgrades oudated and unpinned formulae, and removes stale and outdated downloads and versions. |
| bcubo   | `bu && bco` | Fetch the newest version of Homebrew and all formulae, then list outdated casks. |
| bubobco | `bubo && bco` | Fetch the newest version of Homebrew and all formulae, then list outdated formulae and casks.
| bcubc   | `brew cask reinstall $(bco) && bc` | Updates outdated casks, then runs cleanup. |