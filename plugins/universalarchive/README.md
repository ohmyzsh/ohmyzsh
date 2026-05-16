# universalarchive plugin

The `universalarchive` plugin provides a convenient command-line interface for archiving files and directories using a wide variety of compression formats - without having to remember the exact syntax for each tool.

To enable it, add `universalarchive` to the plugins array in your `.zshrc` file:

```zsh
plugins=(... universalarchive)
```

## Features
 - Compress files and directories using a simple, unified command: ua <format> <files>
 - Automatically detects file/directory names to generate appropriate output names
 - Supports fallback naming if an output file already exists
 - Works with many common and advanced compression formats
 - Designed for simplicity and quick use in the terminal

## Usage

Basic command format:
```sh
ua <format> <files...>
```
- `<format>`: the archive format to use (e.g., `zip`, `tar.gz`, `xz`, `7z`, etc.)
- `<files...>`: one or more files or directories to compress

## Examples:

Compresses `notes.txt` and `images` into `notes.zip`
```sh
ua zip notes.txt images/
```

Creates `myproject.tar.gz`
```sh
ua tar.gz myproject/
```

Compresses all .log files into `current_folder.xz`
```sh
ua xz *.log
```

The plugin will generate a default archive filename based on the input:
 - For a file, the output is derived from the file name without its extension.
 - For a directory, it uses the directory name.
 - For multiple files, it uses the name of the common parent directory.

 If the output file already exists, a unique filename is generated using `mktemp`.

## Supported Archive Formats

| Format           | Description                    | Tool Used        |
|:-----------------|:-------------------------------|:-----------------|
| `7z`             | 7zip archive                   | `7z`             |
| `bz2`            | Bzip2-compressed file          | `bzip2`          |
| `gz`             | Gzip-compressed file           | `gzip`           |
| `lzma`           | LZMA-compressed file           | `lzma`           |
| `lzo`            | LZO-compressed file            | `lzop`           |
| `rar`            | WinRAR archive                 | `rar`            |
| `tar`            | Uncompressed tarball           | `tar`            |
| `tbz`,`tar.bz2`  | Tarball compressed with Bzip2  | `tar + bzip2`    |
| `tgz`,`tar.gz`   | Tarball compressed with Gzip   | `tar + gzip`     |
| `tlz`,`tar.lzma` | Tarball compressed with LZMA   | `tar + lzma`     |
| `txz`,`tar.xz`   | Tarball compressed with LZMA2  | `tar + xz`       |
| `tZ`,`tar.Z`     | Tarball compressed with LZW    | `tar + compress` |
| `xz`             | XZ-compressed file             | `xz`             |
| `Z`              | LZW-compressed file            | `compress`       |
| `zip`            | Standard Zip archive           | `zip`            |
| `zst`            | Zstandard-compressed file      | `zstd`           |

 > Note: Some formats may require specific tools to be installed on your system (e.g. `7z`, `rar`, `lzop`, `zstd`). Make sure these tools are available in your `$PATH`.

## Auto-Completion

The plugin provides tab-completion for supported formats and input files. Type `ua <TAB>` to see available formats, and `ua <format> <TAB>` to browse files.
