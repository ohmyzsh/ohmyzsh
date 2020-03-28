# brew plugin

The plugin adds several aliases for common [brew](https://brew.sh) commands.

To use it, add `brew` to the plugins array of your zshrc file:
```
plugins=(... brew)
```

## Aliases

| Alias  | Command              | Description   |
|--------|----------------------|---------------|
| brewp  | `brew pin`           | Pin a specified formulae, preventing them from being upgraded when issuing the brew upgrade <formulae> command. |
| brews  | `brew list -1`       | List installed formulae, one entry per line, or the installed files for a given formulae. |
| brewsp | `brew list --pinned` | Show the versions of pinned formulae, or only the specified (pinned) formulae if formulae are given. |
| bubo   | `brew update && brew outdated` | Fetch the newest version of Homebrew and all formulae, then list outdated formulae. |
| bubc   | `brew upgrade && brew cleanup` | Upgrade outdated, unpinned brews (with existing install options), then removes stale lock files and outdated downloads for formulae and casks, and removes old versions of installed formulae. |
| bubu   | `bubo && bubc`       | Updates Homebrew, lists outdated formulae, upgrades oudated and unpinned formulae, and removes stale and outdated downloads and versions. |
| bcubo  | `brew update && brew cask outdated` | Fetch the newest version of Homebrew and all formulae, then list outdated casks. |
| bcubc  | `brew cask reinstall $(brew cask outdated) && brew cleanup` | Updates outdated casks, then runs cleanup. |
| bsl    | `brew services list` | List all running services for the current user (or root). |
| bsr    | `brew services run` | Run the service formula without registering to launch at login (or boot). |
| bson   | `brew services start` | Start the service formula immediately and register it to launch at login (or boot). |
| bsoff  | `brew services stop` | Stop the service formula immediately and unregister it from launching at login (or boot). |
