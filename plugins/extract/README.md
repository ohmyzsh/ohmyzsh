# extract plugin

This plugin defines a function called `extract` that extracts the archive file
you pass it, and it supports a wide variety of archive filetypes.

This way you don't have to know what specific command extracts a file, you just
do `extract <filename>` and the function takes care of the rest.

To use it, add `extract` to the plugins array in your zshrc file:

```zsh
plugins=(... extract)
```

## Supported file extensions

| Extension         | Description                          |
|:------------------|:-------------------------------------|
| `7z`              | 7zip file                            |
| `Z`               | Z archive (LZW)                      |
| `apk`             | Android app file                     |
| `aar`             | Android library file                 |
| `bz2`             | Bzip2 file                           |
| `deb`             | Debian package                       |
| `gz`              | Gzip file                            |
| `ipsw`            | iOS firmware file                    |
| `jar`             | Java Archive                         |
| `lzma`            | LZMA archive                         |
| `rar`             | WinRAR archive                       |
| `sublime-package` | Sublime Text package                 |
| `tar`             | Tarball                              |
| `tar.bz2`         | Tarball with bzip2 compression       |
| `tar.gz`          | Tarball with gzip compression        |
| `tar.xz`          | Tarball with lzma2 compression       |
| `tar.zma`         | Tarball with lzma compression        |
| `tbz`             | Tarball with bzip compression        |
| `tbz2`            | Tarball with bzip2 compression       |
| `tgz`             | Tarball with gzip compression        |
| `tlz`             | Tarball with lzma compression        |
| `txz`             | Tarball with lzma2 compression       |
| `war`             | Web Application archive (Java-based) |
| `xpi`             | Mozilla XPI module file              |
| `xz`              | LZMA2 archive                        |
| `zip`             | Zip archive                          |

See [list of archive formats](https://en.wikipedia.org/wiki/List_of_archive_formats) for
more information regarding archive formats.
