# Shopify CLI plugin

This plugin adds aliases, helper functions and completion for the
[Shopify CLI](https://shopify.dev/docs/api/shopify-cli).

To use it, add `shopify` to the plugins array in your zshrc file:

```zsh
plugins=(... shopify)
```

## Requirements

[Shopify CLI](https://shopify.dev/docs/api/shopify-cli) 4.0 or newer, installed
and on your `PATH`. The plugin does nothing if it is not:

```zsh
npm install -g @shopify/cli
# or
brew tap shopify/shopify && brew install shopify-cli
```

## Aliases

| Alias  | Command   | Description            |
| :----- | :-------- | :--------------------- |
| `shop` | `shopify` | The Shopify CLI itself |

## Functions

| Function       | Description                                                                        |
| :------------- | :--------------------------------------------------------------------------------- |
| `shopd`        | Runs `theme dev`, `app dev` or `hydrogen dev`, whichever fits the current project   |
| `shopi`        | Shows what the current project is connected to                                      |
| `shopify_here` | Prints the kind of Shopify project you are in and the commands worth running in it  |
| `shopify`      | Wraps the CLI to confirm before irreversible commands. See Settings                 |

`shopd` and `shopi` work out which topic applies by looking at the project you
are standing in, so you do not have to remember whether this directory is a
theme, an app or a Hydrogen storefront. They complete like the command they
stand in for, so in a theme `shopd --<TAB>` offers the flags of
`shopify theme dev`.

## Completion

Every command completes with a description of what it does, at every level, and
so do their flags, short forms and allowed values. `--environment` completes
from the `[environments.*]` sections of your local `shopify.theme.toml` or
`shopify.app.toml`.

The Shopify CLI ships no completion generator of its own, so `_shopify` is
generated from `shopify commands --json` and kept in this repository. It targets
Shopify CLI 4.x.

## Settings

Set these with `zstyle` in your zshrc, before Oh My Zsh is sourced.

### Confirming destructive commands

```zsh
zstyle ':omz:plugins:shopify' confirm-destructive no
```

By default the plugin asks for confirmation before three irreversible
operations:

- `shopify theme push` with `--live`/`-l` or `--publish`/`-p`, which overwrites
  or publishes the live storefront
- `shopify theme delete`, which the CLI's own help describes as impossible to
  undo
- `shopify app deploy --allow-deletes`, which can permanently remove extensions

Nothing else is intercepted, and the prompt is skipped when the command already
carries `--force`/`-f` or when stdin is not a terminal, so scripts, pipelines
and CI are unaffected. Set the style to `no` to turn the prompt off entirely.

### Completing theme IDs

```zsh
zstyle ':omz:plugins:shopify' dynamic-theme-completion yes
```

Off by default. When enabled, `--theme` is completed from
`shopify theme list --json`, showing each theme's name and role next to its ID
instead of making you copy IDs by hand. It is opt-in because it runs the CLI and
makes a network call when you press <kbd>Tab</kbd>, and because it needs you to
be authenticated. Results are cached for five minutes.

### Disabling the aliases

This works for every Oh My Zsh plugin:

```zsh
zstyle ':omz:plugins:shopify' aliases no
```

## Caveats

- `shopify` is a shell function here. Run `command shopify` to reach the binary
  directly.
- When a project has its own copy of the CLI in `node_modules/.bin/shopify`,
  that one is used in preference to the global install. App and Hydrogen
  projects normally pin the CLI in `package.json`, and running a different
  global version against them is a common source of confusing errors.
- `--password` and `--store-password` are unrelated, and you often need both.
  `--password` is the CLI's own authentication token, from the Theme Access app
  or the Admin API. `--store-password` is the password for a
  password-protected storefront.
- `shopify theme push` deletes remote files that are missing locally, and
  `shopify theme pull` deletes local files that are missing remotely, unless you
  pass `--nodelete`/`-n`. The plugin does not prompt for these.
