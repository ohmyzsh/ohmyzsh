# arcanist

This plugin adds aliases for [Arcanist](https://secure.phabricator.com/book/phabricator/article/arcanist/),
a command-line interface for [Phabricator](https://secure.phabricator.com/).

To use it, add `arcanist` to the plugins array in your zshrc file:

```zsh
plugins=(... arcanist)
```

## Aliases

| Alias   | Command                            |
| ------- | ---------------------------------- |
| ara     | `arc amend`                        |
| arb     | `arc branch`                       |
| arbl    | `arc bland`                        |
| arco    | `arc cover`                        |
| arci    | `arc commit`                       |
| ard     | `arc diff`                         |
| ardnu   | `arc diff --nounit`                |
| ardnupc | `arc diff --nounit --plan-changes` |
| ardpc   | `arc diff --plan-changes`          |
| are     | `arc export`                       |
| arh     | `arc help`                         |
| arho    | `arc hotfix`                       |
| arl     | `arc land`                         |
| arli    | `arc lint`                         |
| arls    | `arc list`                         |
| arpa    | `arc patch`                        |
