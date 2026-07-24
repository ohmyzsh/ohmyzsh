# Quasar framework
https://quasar.dev

This plugin makes quasar commands using easier

To start using it, add the `quasar` plugin to your `plugins` array in `~/.zshrc`:

```zsh
plugins=(... quasar)
```

## Common aliases

| Alias                  | Command                        | Description                                                                 |
| ---------------------- | ------------------------------ | --------------------------------------------------------------------------- |
| q                      | quasar                         | Run the quasar command itself                                               |
| qc                     | quasar create                  | Create a project folder                                                     |
| qi                     | quasar info                    | Display info about your machine (and your App if in a project folder)       |
| qu                     | quasar upgrade                 | Check (and optionally) upgrade Quasar packages from a Quasar project folder |
| qs                     | quasar server                  | Create an ad-hoc server on App's distributables                             |

## Common aliases in project directory
These are not in the plugin these coming from quasar itself

| Alias                  | Command                        | Description                                                                 |
| ---------------------- | ------------------------------ | --------------------------------------------------------------------------- |
| qd                     | quasar dev                     | Start a dev server for your App                                             |
| qb                     | quasar build                   | Build your app for production                                               |
| qcl                    | quasar clean                   | Clean all build artifacts                                                   |
| qn                     | quasar new                     | Quickly scaffold page/layout/component/... vue file                         |
| qnp                    | quasar new page                | Quickly scaffold page vue file                                              |
| qnl                    | quasar new layout              | Quickly scaffold layout vue file                                            |
| qnc                    | quasar new component           | Quickly scaffold component vue file                                         |
| qnb                    | quasar new boot                | Quickly scaffold boot vue file                                              |
| qns                    | quasar new store               | Quickly scaffold store vue file                                             |
| qm                     | quasar mode                    | Add/remove Quasar Modes for your App                                        |
| qin                    | quasar inspect                 | Inspect generated Webpack config                                            |
| qe                     | quasar ext                     | Manage Quasar App Extensions                                                |
| qea                    | quasar ext add                 | Add Quasar App Extension                                                    |
| qer                    | quasar ext remove              | Remove Quasar App Extension                                                 |
| qr                     | quasar run                     | Run specific command provided by an installed Quasar App Extension          |
| qde                    | quasar describe                | Describe a Quasar API (component)                                           |
| qt                     | quasar test                    | Run @quasar/testing App Extension command                                   |
