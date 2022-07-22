# Swift Package Manager

## Description

This plugin provides a few utilities that make you faster on your daily work with the [Swift Package Manager](https://github.com/apple/swift-package-manager), as well as autocompletion for Swift 5.1.

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
