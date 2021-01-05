# universalarchive plugin

Lets you compress files by a command `ua <format> <files>` into various compression formats;
namely, `<format>` could be `zip`, `xz`, ..

## Usage

For example, the command
```sh
ua xz *.html
```
will compress all `html` files in directory `folder` into `folder.xz`.

This command saves you from having to remember which command line arguments compress a file.

## Installation

To enable it, add `universalarchive` to the plugins array in your zshrc file:

```zsh
plugins=(... universalarchive)
```

## Supported file extensions

| Extension         | Description                          |
|:------------------|:-------------------------------------|
| `7z`              | 7zip file                            |
| `Z`               | Z archive (LZW)                      |
| `bz2`             | Bzip2 file                           |
| `gz`              | Gzip file                            |
| `lzma`            | LZMA archive                         |
| `lzo`             | LZO archive                          |
| `rar`             | WinRAR archive                       |
| `tar`             | Tarball                              |
| `tar.bz2`         | Tarball with bzip2 compression       |
| `tar.gz`          | Tarball with gzip compression        |
| `tar.xz`          | Tarball with lzma2 compression       |
| `tar.lzma`        | Tarball with lzma compression        |
| `tbz`             | Tarball with bzip compression        |
| `tbz2`            | Tarball with bzip2 compression       |
| `tgz`             | Tarball with gzip compression        |
| `tlz`             | Tarball with lzma compression        |
| `txz`             | Tarball with lzma2 compression       |
| `xz`              | LZMA2 archive                        |
| `zip`             | Zip archive                          |
| `zst`             | Zstd archive                         |

See [list of archive formats](https://en.wikipedia.org/wiki/List_of_archive_formats) for more information regarding the archive formats.
