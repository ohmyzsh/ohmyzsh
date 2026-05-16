# Ionic plugin

This plugin adds completion for the [Ionic CLI](https://ionicframework.com/docs/cli),
as well as some aliases for common Ionic commands.

To use it, add `ionic` to the plugins array in your zshrc file:

```zsh
plugins=(... ionic)
```

## Aliases

| Alias | Command                              | Description                                                      |
|-------|--------------------------------------|------------------------------------------------------------------|
| iv    | `ionic --version`                    | Check Ionic version                                              |
| ih    | `ionic --help`                       | Ionic help command                                               |
| ist   | `ionic start`                        | Create a new project                                             |
| ii    | `ionic info`                         | Print system/environment info                                    |
| is    | `ionic serve`                        | Start a local dev server for app dev/testing                     |
| icba  | `ionic cordova build android`        | Build web assets and prepare app for android platform targets    |
| icbi  | `ionic cordova build ios`            | Build web assets and prepare app for ios platform targets        |
| icra  | `ionic cordova run android`          | Run an Ionic project on a connected android device               |
| icri  | `ionic cordova run ios`              | Run an Ionic project on a connected ios device                   |
| icrsa | `ionic cordova resources android`    | Automatically create icon and splash screen resources for android|
| icrsi | `ionic cordova resources ios`        | Automatically create icon and splash screen resources for ios    |
| icpaa | `ionic cordova platform add android` | Add Cordova android platform targets                             |
| icpai | `ionic cordova platform add ios`     | Add Cordova ios platform targets                                 |
| icpra | `ionic cordova platform rm android`  | Remove Cordova platform targets                                  |
| icpri | `ionic cordova platform rm ios`      | Remove Cordova platform targets                                  |
