# Exegol plugin

The Exegol plugin provides useful aliases

To use it, add `exegol` to the plugins array of your zshrc file:

```zsh
plugins=(... exegol)
```

## Aliases

| Alias   | Command                          | Description                                               |
| :------ | :------------------------------- | :-------------------------------------------------------- |
| `e`     | `exegol`                         | Shorthand for exegol command                              |
| `ei`    | `exegol info`                    | Displays exegol information                               |
| `eu`    | `exegol update`                  | Updates exegol to the latest version                      |
| `es`    | `exegol start`                   | Starts an Exegol instance                                 |
| `esn`   | `exegol start [default] nightly` | Starts a nightly Exegol instance                          |
| `esf`   | `exegol start [default] full`    | Starts a full Exegol instance                             |
| `esf!`  | `esf --privileged`               | Starts a full Exegol instance with privileged access      |
| `esn!`  | `esn --privileged`               | Starts a nightly Exegol instance with privileged access   |
| `etmpn` | `exegol exec --tmp nightly`      | Executes a command in a temporary nightly Exegol instance |
| `etmpf` | `exegol exec --tmp full`         | Executes a command in a temporary full Exegol instance    |
| `estp`  | `exegol stop`                    | Stops an Exegol instance                                  |
| `estpa` | `exegol stop --all`              | Stops all Exegol instances                                |
| `erm`   | `exegol remove`                  | Removes an Exegol instance                                |
| `erm!`  | `exegol remove --force`          | Removes an Exegol instance forcefully                     |
| `erma`  | `exegol remove --all`            | Removes all Exegol instances                              |
| `erma!` | `exegol remove --force --all`    | Removes all Exegol instances forcefully                   |
