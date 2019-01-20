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
| bcbu   | `brew cleanup && brew upgrade` | Reverse-order of the above so that the least outdated elements of the above list are kept, after an upgrade of outdated, unpinned brews. |
| bubu   | `bubo && bubc`       | Updates Homebrew, lists outdated formulae, upgrades oudated and unpinned formulae, and removes stale and outdated downloads and versions. |
| bucu   | `bubo && bcbu`       | Updates Homebrew, lists outdated formulae, removes stale and outdated downloads and versions, and upgrades oudated and unpinned formulae. |
