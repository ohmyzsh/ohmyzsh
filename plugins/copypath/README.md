# copypath plugin

Copies the path of given directory or file to the system clipboard.

To use it, add `copypath` to the plugins array in your zshrc file:

```zsh
plugins=(... copypath)
```

## Usage

- `copypath`: copies the absolute path of the current directory.

- `copypath <file_or_directory>`: copies the absolute path of the given file.
