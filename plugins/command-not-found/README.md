# command-not-found plugin

This plugin uses the command-not-found package for zsh to provide suggested packages to be installed if a command cannot be found.

To use it, add `command-not-found` to the plugins array of your zshrc file:

```zsh
plugins=(... command-not-found)
```

An example of how this plugin works in Ubuntu:
```
$ mutt
The program 'mutt' can be found in the following packages:
 * mutt
 * mutt-kz
 * mutt-patched
Try: sudo apt install <selected package>
```

### Supported platforms

It works out of the box with the command-not-found packages for:

- [Ubuntu](https://www.porcheron.info/command-not-found-for-zsh/)
- [Debian](https://packages.debian.org/search?keywords=command-not-found)
- [Arch Linux](https://wiki.archlinux.org/index.php/Pkgfile#Command_not_found)
- [macOS (Homebrew)](https://github.com/Homebrew/homebrew-command-not-found)
- [Fedora](https://fedoraproject.org/wiki/Features/PackageKitCommandNotFound)
- [NixOS](https://github.com/NixOS/nixpkgs/tree/master/nixos/modules/programs/command-not-found)
- [Termux](https://github.com/termux/command-not-found)
- [SUSE](https://www.unix.com/man-page/suse/1/command-not-found/)

You can add support for other platforms by submitting a Pull Request.
