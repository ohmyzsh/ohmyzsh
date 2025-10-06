# forklift

Plugin for ForkLift, an FTP application for OS X.

To use it, add `forklift` to the plugins array in your zshrc file:

```zsh
plugins=(... forklift)
```

## Requirements

* [ForkLift](https://binarynights.com/)

## Usage

`fl [<file_or_folder>]`

* If `fl` is called without arguments then the current folder is opened in ForkLift. This is equivalent to `fl .`.

* If `fl` is called with a directory as the argument, then that directory is opened in ForkLift

* If `fl` is called with a non-directory file as the argument, then the file's parent directory is opened.
