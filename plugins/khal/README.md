# Khal

This plugin provides completion for [khal](https://lostpackets.de/khal/) and some
aliases for frequent khal commands.

To use it, add khal to the plugins array of your zshrc file:
```
plugins=(... khal)
```

Completion from [https://github.com/pimutils/khal/blob/master/misc/__khal](https://github.com/pimutils/khal/blob/master/misc/__khal)

## Aliases

| Alias     | Command                  | Description                                                      |
|-----------|--------------------------|------------------------------------------------------------------|
| k         | `khal`                   | Khal main command                                                |
| kn        | `khal new`               | Add new event                                                    |
| kl        | `khal list`              | Show list of events                                              |
| ks        | `khal search`            | Search for events                                                |
