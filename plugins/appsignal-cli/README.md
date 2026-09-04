# AppSignal CLI plugin

This plugin adds aliases, guard rails and completion for the
[AppSignal CLI](https://docs.appsignal.com/cli).

To use it, add `appsignal-cli` to the plugins array in your zshrc file:

```zsh
plugins=(... appsignal-cli)
```

## Requirements

[AppSignal CLI](https://docs.appsignal.com/cli) 2.1 or newer, installed and on
your `PATH`. The plugin does nothing if it is not:

```zsh
brew install appsignal/appsignal-cli/appsignal-cli
# or
curl -sSL https://github.com/appsignal/appsignal-cli/releases/latest/download/install.sh | sudo sh
```

Most commands need `appsignal-cli auth login` first.

## Aliases

| Alias   | Command                        | Description                        |
| :------ | :----------------------------- | :--------------------------------- |
| `asig`  | `appsignal-cli`                | The AppSignal CLI itself           |
| `aslog` | `appsignal-cli logs tail`      | Stream log lines as they arrive    |
| `asinc` | `appsignal-cli incidents list` | List incidents for an application  |

`aslog` and `asinc` complete like the commands they stand in for, so
`aslog --<TAB>` offers the flags of `appsignal-cli logs tail`.

## Functions

| Function        | Description                                                        |
| :-------------- | :----------------------------------------------------------------- |
| `appsignal-cli` | Wraps the CLI to confirm before irreversible commands. See Settings |

## Completion

Every command completes with a description of what it does, at every level, and
so do their flags and allowed values: incident states and severities, sort
orders, log severities, trigger fields and comparison operators, output formats
and skill targets. `samples` and `sample` complete like `traces`, as they do in
the CLI itself.

`--org` completes offline from the `org` key of your project's
`.appsignal.toml` and of the global config.

The AppSignal CLI ships no completion generator of its own, so `_appsignal-cli`
is written from its command definitions and kept in this repository. It targets
AppSignal CLI 2.1.x.

## Settings

Set these with `zstyle` in your zshrc, before Oh My Zsh is sourced.

### Confirming destructive commands

```zsh
zstyle ':omz:plugins:appsignal-cli' confirm-destructive no
```

By default the plugin asks for confirmation before four operations that the CLI
itself performs without a prompt:

- `appsignal-cli logs metrics delete`
- `appsignal-cli logs triggers delete`
- `appsignal-cli triggers archive`, which also closes the trigger's alerts and
  incidents
- `appsignal-cli incidents update --state CLOSED` when it names more than one
  incident, since that flag accepts a comma-separated list

Nothing else is intercepted, and the prompt is skipped when stdin is not a
terminal, so scripts, pipelines and CI are unaffected. Set the style to `no` to
turn the prompt off entirely, or run `command appsignal-cli` for a single
invocation.

### Completing applications

```zsh
zstyle ':omz:plugins:appsignal-cli' dynamic-app-completion yes
```

Off by default. When enabled, `--app`, `--app-id` and `--environment` are
completed from `appsignal-cli apps list --output json`, showing each
application's name and environment next to its ID instead of making you copy
IDs by hand. It is opt-in because it runs the CLI and makes a network call when
you press <kbd>Tab</kbd>, and because it needs you to be authenticated. Results
are cached for five minutes.

### Disabling the aliases

This works for every Oh My Zsh plugin:

```zsh
zstyle ':omz:plugins:appsignal-cli' aliases no
```

## Caveats

- `appsignal-cli` and the AppSignal Ruby gem's `appsignal` command are different
  tools. The gem's command installs and diagnoses the agent inside your app;
  this one queries your data. The plugin deliberately leaves `appsignal` alone,
  so it keeps working in projects that use the gem.
- `appsignal-cli` is a shell function here. Run `command appsignal-cli` to reach
  the binary directly.
- Most commands need exactly one of `--app-id` or `--app`. `--environment` only
  narrows `--app`; it does nothing next to `--app-id`.
- `appsignal-cli project init` writes `.appsignal.toml`, and `auth login` then
  stores OAuth tokens in it. Do not commit that file.
- `incidents delete-note`, `auth logout` and the `--clear-*` flags of
  `logs metrics update` and `logs triggers update` are destructive too, but are
  not prompted for: each affects a single note, login or field.
- `triggers create` and `triggers update` have their own `--format`, for the
  format of the metric value. Everywhere else `--format` is a synonym for
  `--output`.
- The CLI sends usage telemetry by default. `APPSIGNAL_CLI_TELEMETRY=0` turns it
  off, and `APPSIGNAL_CLI_DEBUG=1` shows internal errors.
