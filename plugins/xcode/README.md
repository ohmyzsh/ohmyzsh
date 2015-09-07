# Xcode

## Description

This plugin provides a few utilities that can help you on your daily use of Xcode and iOS development.

To start using it, add the `xcode` plugin to your `plugins` array:

```zsh
plugins=(... xcode)
```


## Aliases

| Alias | Description                              | Command                                        |
|-------|------------------------------------------|------------------------------------------------|
| xcb   | Build Xcode projects and workspaces      | xcodebuild                                     |
| xcdd  | Purge all temporary build information    | rm -rf ~/Library/Developer/Xcode/DerivedData/* |
| xcp   | Show currently selected Xcode directory  | xcode-select --print-path                      |
| xcsel | Select different Xcode directory by path | sudo xcode-select --switch                     |



## Functions

- **`xc`**:
  Open one of the `.xcworkspace` and `.xcodeproj` files that it can find in the current working directory.
  Returns 1 if it didn't find any relevant files.

- **`simulator`**:
  Open the iOS Simulator from your command line, dependant on whichever is the active developer directory for Xcode.

- **`xcselv`**:
  Select different Xcode by version. Example: `xcselv 6.2`
