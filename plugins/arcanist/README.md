## arcanist

This plugin adds many useful aliases for [arcanist](https://github.com/phacility/arcanist).

To use it, add `arcanist` to the plugins array of your zshrc file:

```zsh
plugins=(... arcanist)
```

## Aliases

| Alias   | Command                            |
| ------- | ---------------------------------- |
| ara     | `arc amend`                        |
| arb     | `arc branch`                       |
| arco    | `arc cover`                        |
| arci    | `arc commit`                       |
| ard     | `arc diff`                         |
| ardc    | `arc diff --create`                |
| ardp    | `arc diff --preview`               |
| ardnu   | `arc diff --nounit`                |
| ardnupc | `arc diff --nounit --plan-changes` |
| ardpc   | `arc diff --plan-changes`          |
| are     | `arc export`                       |
| arh     | `arc help`                         |
| arl     | `arc land`                         |
| arli    | `arc lint`                         |
| arls    | `arc list`                         |
| arpa    | `arc patch`                        |

## Functions

The following functions make copy pasting revision ids from the URL bar of your browser
easier, as they allow for copy pasting the whole URL. For example: `ardu` accepts
both `https://arcanist-url.com/<REVISION>` as well as `<REVISION>`.

| Function                  | Command                           |
| ------------------------- | --------------------------------- |
| ardu [URL or revision_id] | `arc diff --update` [revision_id] |
| arpa [URL or revision_id] | `arc patch` [revision_id]         |
