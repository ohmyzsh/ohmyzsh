# Xcode

## Description

This plugin provides a few utilities that can help you on your daily use of Xcode and iOS development.

To start using it, add the `xcode` plugin to your `plugins` array in `~/.zshrc`:

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

###  `xc`

Opens the current directory in Xcode as an Xcode project. This will open one of the `.xcworkspace` and `.xcodeproj` files that it can find in the current working directory. You can also specify a directory to look in for the Xcode files.
Returns 1 if it didn't find any relevant files.

###  `simulator`

Opens the iOS Simulator from your command line, dependent on whichever is the active developer directory for Xcode. (That is, it respects the `xcsel` setting.)

### `xcselv`

Selects different Xcode installations by version name. This is like `xcsel`, except it takes just a version name as an argument instead of the full path to the Xcode installation. Uses the naming conventions described below.

* `xcselv <version>` selects a version
 * Example: `xcselv 6.2`
* `xcselv default` selects the default unversioned `Applications/Xcode.app`
* `xcselv` with no argument lists the available Xcode versions in a human-readable format
* `xcselv -l` lists the installed Xcode versions
* `xcselv -L` lists the installed Xcode versions in a short version-name-only format
* `xcselv -p` prints info about the active Xcode version
* `xcselv -h` prints a help message

The option parsing for `xcselv` is naive. Options may not be combined, and only the first option is recognized.

## Multiple Xcode Versions

The `xcselv` command provides support for switching between different Xcode installations using just a version number. Different Xcode versions are identified by file naming conventions.

### Versioned Xcode Naming Conventions

Apple does not seem to explicitly define or provide tooling support for a naming convention or other organizational mechanism for managing versioned Xcode installations. Apple seems to have released beta versions with both `Xcode<version>.app` and `Xcode-<version>.app` style names in the past, and both styles show up in forum and blog discussions.

We've adopted the following naming convention:

* Versioned Xcode installations are identified by the name `Xcode-<version>` or `Xcode<version>`.
* The `-` separating `"Xcode"` and the version name is optional, and may be replaced by a space.
* The versioned name may be applied to the `Xcode.app` itself, or a subdirectory underneath `Applications/` containing it.
* You cannot version both the `Xcode.app` filename itself and the containing subfolder.
* Thus, all of the following are equivalent.
 * `Applications/Xcode-<version>.app`
 * `Applications/Xcode-<version>/Xcode.app`
 * `Applications/Xcode<version>.app`
 * `Applications/Xcode <version>.app`
 * `Applications/Xcode <version>/Xcode.app`
* Both the system `/Applications/` and user `$HOME/Applications/` directories are searched.
 * The user's `$HOME/Applications/` takes precedence over `/Applications` for a given version.
 * If multiple naming variants within the same `Applications/` folder indicate the same version (for example, `Xcode-3.2.1.app`, `Xcode3.2.1.app`, and `Xcode-3.2.1/Xcode.app`), the precedence order is unspecified and implementation-dependent.
* The `<version>` may be any string that is valid in a filename.
* The special version name `"default"` refers to the "default" unversioned Xcode at `Applications/Xcode.app` (in either `/Applications/` or `$HOME/Applications/`).
* Version names may not start with ``"-"`` or whitespace.

The restrictions on the naming convention may need to be tightened in the future. In particular, if there are other well-known applications whose names begin with the string `"Xcode"`, the strings allowed for `<version>` may need to be restricted to avoid colliding with other applications. If there's evidence that one of these naming techniques is strongly favored either in practice or by Apple, we may tighten the naming convention to favor it.

## Caveats

Using `xcsel` or `xcselv` to select an Xcode that is installed under your `$HOME` may break things for other users, depending on your system setup. We let you do this anyway because some people run OS X as effectively single-user, or have open permissions so this will work. You could also use `$DEVELOPER_DIR` as an alternative to `xcsel` that is scoped to the current user or session, instead of a global setting.

This does not verify that the version name in the Xcode filename matches the actual version of that binary. It is the user's responsibility to get the names right.
