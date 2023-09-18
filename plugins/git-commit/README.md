# git-commit plugin

The git-commit plugin adds several [git aliases](https://www.git-scm.com/docs/git-config#Documentation/git-config.txt-alias) for [conventional commit](https://www.conventionalcommits.org/en/v1.0.0/#summary) messages.

To use it, add `git-commit` to the plugins array in your zshrc file:

```zsh
plugins=(... git-commit)
```

## Syntax

```zshrc
git <type> [(-s, --scope) "<scope>"] "<message>"
```

> ⚠️ Single/Double quotes around the scope and message are required

Where `type` is one of the following:

- `build`
- `chore`
- `ci`
- `docs`
- `feat`
- `fix`
- `perf`
- `refactor`
- `revert`
- `style`
- `test`

## Examples

`git style "remove trailing whitespace"` -> `git commit -m "style: remove trailing whitespace"`  
`git fix -s "router" "correct redirect link"` -> `git commit -m "fix(router): correct redirect link"`
