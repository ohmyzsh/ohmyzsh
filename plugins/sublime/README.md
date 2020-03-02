# sublime

Plugin for [Sublime Text](https://www.sublimetext.com/), a cross platform text and code editor,
available for Linux, macOS, and Windows.

To use the plugin, add `sublime` to the plugins array of your zshrc file:

```zsh
plugins=(... sublime)
```

Sublime Text has to be installed to use the plugin.

## Usage

The plugin defines several aliases, such as:

- `st`: opens Sublime Text. If passed a file or directory, Sublime Text will open it.

- `stt`: open Sublime Text on the current directory.

- `sst`: if `sudo` is available, `sst` will open Sublime Text with root permissions, so that
  you can modify any file or directory that you pass it. Useful to edit system files.

There are also a few functions available:

- `find_project` (or `stp` alias): if called, the function will search for a `.sublime-project` file
  on the current directory or its parents, until it finds none.

  If there is no `.sublime-project` file but the current folder is in a Git repository, it will open
  Sublime Text on the root directory of the repository.

  If there is no Git repository, it will then open Sublime Text on the current directory.

- `create_project` (or `stn` alias): if called without an argument, create a stub `.sublime-project`
  file in the current working directory, if one does not already exist. If passed a directory, create
  a stub `.sublime-project` file in it.
