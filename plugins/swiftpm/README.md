# Swift Package Manager

## Description

This plugin provides a few utilities that make you faster on your daily work with the [Swift Package Manager](https://github.com/apple/swift-package-manager).

To start using it, add the `swiftpm` plugin to your `plugins` array in `~/.zshrc`:

```zsh
plugins=(... swiftpm)
```

## Aliases

| Alias | Description                         | Command                            |
|-------|-------------------------------------|------------------------------------|
| `spi` | Initialize a new package            | `swift package init`               |
| `spf` | Fetch package dependencies          | `swift package fetch`              |
| `spu` | Update package dependencies         | `swift package update`             |
| `spx` | Generates an Xcode project          | `swift package generate-xcodeproj` |
| `sps` | Print the resolved dependency graph | `swift package show-dependencies`  |
| `spd` | Print parsed Package.swift as JSON  | `swift package dump-package`       |

## Autocompletion

The `_swift` file enables autocompletion for Swift Package Manager. Current version supports Swift 5.0


### Updating the autocompletion for new version of Swift

To update autocompletion to the Swift version present on your system:
```
swift package completion-tool generate-zsh-script > ~/.oh-my-zsh/plugins/swiftpm/_swift
```

### Known issues

If `swiftpm` is not added to your zsh plugins list, autocompletion will still be triggered but will result in errors:
```
_values:compvalues:10: not enough arguments
```
