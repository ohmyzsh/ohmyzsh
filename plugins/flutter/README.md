## Flutter plugin

The Flutter plugin provides completion and useful aliases

To use it, add `flutter` to the plugins array of your zshrc file:

```zsh
plugins=(... flutter)
```

## Aliases

| Alias      | Command                 | Description                                                                |
| :--------- | :---------------------- | :------------------------------------------------------------------------- |
| `fl`       | `flutter`               | Shorthand for flutter command                                              |
| `flattach` | `flutter attach`        | Attaches flutter to a running flutter application with enabled observatory |
| `flb`      | `flutter build`         | Build flutter application                                                  |
| `flchnl`   | `flutter channel`       | Switches flutter channel (requires input of desired channel)               |
| `flc`      | `flutter clean`         | Cleans flutter project                                                     |
| `fldvcs`   | `flutter devices`       | List connected devices (if any)                                            |
| `fldoc`    | `flutter doctor`        | Runs flutter doctor                                                        |
| `flpub`    | `flutter pub`           | Shorthand for flutter pub command                                          |
| `flget`    | `flutter pub get`       | Installs dependencies                                                      |
| `flr`      | `flutter run`           | Runs flutter app                                                           |
| `flrd`     | `flutter run --debug`   | Runs flutter app in debug mode (default mode)                              |
| `flrp`     | `flutter run --profile` | Runs flutter app in profile mode                                           |
| `flrr`     | `flutter run --release` | Runs flutter app in release mode                                           |
| `flupgrd`  | `flutter upgrade`       | Upgrades flutter version depending on the current channel                  |
