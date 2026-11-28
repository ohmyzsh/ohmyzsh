# MacOS plugin

This plugin provides a few utilities to make it more enjoyable on macOS (previously named OSX).

To start using it, add the `macos` plugin to your plugins array in `~/.zshrc`:

```zsh
plugins=(... macos)
```

## Supported Terminals
- [iTerm](https://iterm.sourceforge.net/)
- [iTerm2](https://iterm2.com/)
- [Hyper](https://hyper.is/)
- [Tabby](https://tabby.sh/)
- [Ghostty](https://ghostty.org)

## Commands

| Command       | Description                                              |
| :------------ | :------------------------------------------------------- |
| `tab`         | Open the current directory in a new tab                  |
| `split_tab`   | Split the current terminal tab horizontally              |
| `vsplit_tab`  | Split the current terminal tab vertically                |
| `ofd`         | Open passed directories (or $PWD by default) in Finder   |
| `pfd`         | Return the path of the frontmost Finder window           |
| `pfs`         | Return the current Finder selection                      |
| `cdf`         | `cd` to the current Finder directory                     |
| `pushdf`      | `pushd` to the current Finder directory                  |
| `pxd`         | Return the current Xcode project directory               |
| `cdx`         | `cd` to the current Xcode project directory              |
| `quick-look`  | Quick-Look a specified file                              |
| `man-preview` | Open man pages in Preview app                            |
| `showfiles`   | Show hidden files in Finder                              |
| `hidefiles`   | Hide the hidden files in Finder                          |
| `itunes`      | _DEPRECATED_. Use `music` from macOS Catalina on         |
| `music`       | Control Apple Music. Use `music -h` for usage details    |
| `spotify`     | Control Spotify and search by artist, album, track…      |
| `rmdsstore`   | Remove .DS_Store files recursively in a directory        |
| `btrestart`   | Restart the Bluetooth daemon                             |
| `freespace`   | Erases purgeable disk space with 0s on the selected disk |

## Acknowledgements

Original author: [Sorin Ionescu](https://github.com/sorin-ionescu)

This application makes use of the following third-party scripts:

[shpotify](https://github.com/hnarayanan/shpotify)

Copyright (c) 2012–2019 [Harish Narayanan](https://harishnarayanan.org/).

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
