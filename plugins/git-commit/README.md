# git-commit plugin

The git-commit plugin adds several git subcommands for
[conventional commit](https://www.conventionalcommits.org/en/v1.0.0/#summary) messages.

To use it, add `git-commit` to the plugins array in your zshrc file:

```zsh
plugins=(... git-commit)
```

## Syntax

```zsh
git <type> [(-s, --scope) "<scope>"] [(-a, --attention)] [(-b, --body) "<body>"] "<message>"
```

Where `type` is one of the following:

- `build`
- `chore`
- `ci`
- `docs`
- `feat`
- `fix`
- `perf`
- `refactor`
- `rev`
- `style`
- `test`
- `wip`

The optional `-b` / `--body` becomes the commit body (a blank line after the subject), as defined by
[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/#summary).

> NOTE: the subcommand for `revert` type is `rev`, as otherwise it conflicts with the
> git command of the same name. It will still generate a commit message in the format
> `revert: <message>`

## Examples

| Git subcommand                                | Command                                              |
| --------------------------------------------- | ---------------------------------------------------- |
| `git style "remove trailing whitespace"`      | `git commit -m "style: remove trailing whitespace"`  |
| `git wip "work in progress"`                  | `git commit -m "wip: work in progress"`              |
| `git fix -s "router" "correct redirect link"` | `git commit -m "fix(router): correct redirect link"` |
| `git rev -s "api" "rollback v2"`              | `git commit -m "revert(api): rollback v2"`           |
| `git feat -s "auth" -b "Keep session across redirects." "add login redirect"` | `git commit -m "feat(auth): add login redirect" -m "Keep session across redirects."` |
