# avd plugin

The avd plugin provides aliases for Android Virtual Device / Android
Emulator commands.

To use it, add avd to the plugins array of your zshrc file:

```zsh
plugins=(... avd)
```

## Requirements

In order to make this work, you will need to have the Android `emulator`
tool set up in your path. This plugin will try to find that tool in
`$ANDROID_HOME` as a last resort, however it will make it slower and may
not work as expected.

## Functions

- `avds` - Lists all the AVDs
- `avd [-v] <n>` - Launches n-th AVD from the AVDs list printed by
  `avds`
  - `-v` will let stdout and stderr print to the console which is
    disabled by default to avoid the clutter
- `find_emulator` - Tries to find the `emulator` tool either in your
  path or `$ANDROID_HOME` directory

## Aliases

- `emus` - Same as `avds`
- `emu [-v] <n>` - Same as `avd [-v] <n>`

## Exemplary usage:
```
~/
> avds
Pixel_2_API_30
Samsung_Tab_A_2019_API_25
Samsung_Tab_A_2019_API_29

~/
> avd 2
Starting emulator: Samsung_Tab_A_2019_API_25
[3] 33463
```
