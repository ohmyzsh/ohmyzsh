# universalarchive plugin

Lets you compress files by a command `ua <format> <files>`, supporting various
compression formats (e.g. 7z, tar.gz, lzma, ...).

To enable it, add `universalarchive` to the plugins array in your zshrc file:

```zsh
plugins=(... universalarchive)
```

## Usage

Run `ua <format> <files>` to compress `<files>` into an archive file using `<format>`.
For example:

```sh
ua xz *.html
```

this command will compress all `.html` files in directory `folder` into `folder.xz`.

This plugin saves you from having to remember which command line arguments compress a file.

## Supported compression formats

| Extension        | Description                    |
|:-----------------|:-------------------------------|
| `7z`             | 7zip file                      |
| `bz2`            | Bzip2 file                     |
| `gz`             | Gzip file                      |
| `lzma`           | LZMA archive                   |
| `lzo`            | LZO archive                    |
| `rar`            | WinRAR archive                 |
| `tar`            | Tarball                        |
| `tbz`/`tar.bz2`  | Tarball with bzip2 compression |
| `tgz`/`tar.gz`   | Tarball with gzip compression  |
| `tlz`/`tar.lzma` | Tarball with lzma compression  |
| `txz`/`tar.xz`   | Tarball with lzma2 compression |
| `tZ`/`tar.Z`     | Tarball with LZW compression   |
| `xz`             | LZMA2 archive                  |
| `Z`              | Z archive (LZW)                |
| `zip`            | Zip archive                    |
| `zst`            | Zstd archive                   |

See [list of archive formats](https://en.wikipedia.org/wiki/List_of_archive_formats) for more information regarding the archive formats.
