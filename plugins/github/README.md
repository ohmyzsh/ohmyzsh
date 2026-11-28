# github plugin

> [!WARNING]
> This plugin is deprecated and will be removed in a future release. It supports
> the legacy [`hub`](https://github.com/mislav/hub) CLI, not the current GitHub
> CLI. For `gh` completion, use the [`gh` plugin](../gh) instead.

The plugin provides compatibility for existing `hub` users by:

- aliasing `git` to `hub` when `hub` is installed;
- adding completion for `hub`; and
- defining convenience functions for creating repositories.

## Migrating to GitHub CLI

Install [GitHub CLI](https://cli.github.com/), replace `github` with `gh` in
your plugin list, and restart your shell:

```zsh
plugins=(... gh)
```

The `gh` plugin supplies completion for the installed GitHub CLI. It does not
alias `git`, because `gh` is not a Git wrapper.

The closest replacement for creating a GitHub repository from an existing
local repository is:

```zsh
gh repo create --source=. --push
```

## Deprecated functions

- `empty_gh` - creates a new repository with a `README.md` and pushes it to GitHub
- `new_gh` - initializes an existing directory and pushes it to GitHub
- `exist_gh` - pushes an existing Git repository to GitHub

These functions remain available during the deprecation period and require
`hub`. They will be removed with the plugin.

If you continue using `hub`, see its documentation for authentication and
configuration details.
