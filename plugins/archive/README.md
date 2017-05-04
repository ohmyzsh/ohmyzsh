# archive plugin

This plugin was copied from `extract plugin` and that guy is awesome. Thanks!

Defines a function called `archive` that get list the archive file
you pass it, and it supports a wide variety of archive filetypes.

This way you don't have to know what specific command list archive a file, you just
do `archive <filename>` and the function takes care of the rest.

To use it, add `archive` to the plugins array in your zshrc file:

```zsh
plugins=(... archive)
```

## Supported file extensions

| Extension         | Description                          |
|:------------------|:-------------------------------------|
| `7z`              | 7zip file                            |
| `rar`             | WinRAR archive                       |
| `tar`             | Tarball                              |
| `tar.bz2`         | Tarball with bzip2 compression       |
| `tar.gz`          | Tarball with gzip compression        |
| `tar.lzma`        | Tarball with lzma compression        |
| `tar.xz`          | Tarball with lzma2 compression       |
| `zip`             | Zip archive                          |

See [list of archive formats](https://en.wikipedia.org/wiki/List_of_archive_formats) for
more information regarding archive formats.

## Contributors
- Diki Andriansyah - diki1aap@gmail.com
