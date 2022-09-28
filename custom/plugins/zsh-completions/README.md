zsh-completions ![GitHub release](https://img.shields.io/github/release/zsh-users/zsh-completions.svg) ![GitHub contributors](https://img.shields.io/github/contributors/zsh-users/zsh-completions.svg) [![IRC](https://img.shields.io/badge/IRC-%23zsh--completions-yellow.svg)](irc://irc.freenode.net/#zsh-completions) [![Gitter](https://badges.gitter.im/zsh-users/zsh-completions.svg)](https://gitter.im/zsh-users/zsh-completions?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
=============

**Additional completion definitions for [Zsh](http://www.zsh.org).**

*This projects aims at gathering/developing new completion scripts that are not available in Zsh yet. The scripts may be contributed to the Zsh project when stable enough.*


## Usage

### Using packages

| System  | Package |
| ------------- | ------------- |
| Debian / Ubuntu | [zsh-completions OBS repository](https://software.opensuse.org/download.html?project=shells%3Azsh-users%3Azsh-completions&package=zsh-completions) |
| Fedora / CentOS / RHEL / Scientific Linux | [zsh-completions OBS repository](https://software.opensuse.org/download.html?project=shells%3Azsh-users%3Azsh-completions&package=zsh-completions) |
| OpenSUSE / SLE | [zsh-completions OBS repository](https://software.opensuse.org/download.html?project=shells%3Azsh-users%3Azsh-completions&package=zsh-completions) |
| Arch Linux / Manjaro / Antergos / Hyperbola | [zsh-completions](https://www.archlinux.org/packages/zsh-completions), [zsh-completions-git](https://aur.archlinux.org/packages/zsh-completions-git) |
| Gentoo / Funtoo | [app-shells/zsh-completions](http://packages.gentoo.org/package/app-shells/zsh-completions)  |
| NixOS | [zsh-completions](https://github.com/NixOS/nixpkgs/blob/master/pkgs/shells/zsh/zsh-completions/default.nix) |
| Void Linux | [zsh-completions](https://github.com/void-linux/void-packages/blob/master/srcpkgs/zsh-completions/template) |
| Slackware | [Slackbuilds](https://slackbuilds.org/repository/14.2/system/zsh-completions/) |
| macOS | [homebrew](https://github.com/Homebrew/homebrew-core/blob/master/Formula/zsh-completions.rb), [MacPorts](https://github.com/macports/macports-ports/blob/master/sysutils/zsh-completions/Portfile)  |
| NetBSD | [pkgsrc](http://ftp.netbsd.org/pub/pkgsrc/current/pkgsrc/shells/zsh-completions/README.html)  |
| FreeBSD | [shells/zsh-completions](https://www.freshports.org/shells/zsh-completions)  |


### Using zsh frameworks

#### [antigen](https://github.com/zsh-users/antigen)

Add `antigen bundle zsh-users/zsh-completions` to your `~/.zshrc`.

#### [oh-my-zsh](http://github.com/robbyrussell/oh-my-zsh)

* Clone the repository inside your oh-my-zsh repo:

        git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions

* Add it to `FPATH` in your `.zshrc` by adding the following line before `source "$ZSH/oh-my-zsh.sh"`:

        fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

Note: adding it as a regular Oh My ZSH! plugin will not work properly (see [#603](https://github.com/zsh-users/zsh-completions/issues/603)).

#### [zinit](https://github.com/zdharma-continuum/zinit)

Add `zinit light zsh-users/zsh-completions` to your `~/.zshrc`.

### Manual installation

* Clone the repository:

        git clone https://github.com/zsh-users/zsh-completions.git

* Include the directory in your `$fpath`, for example by adding in `~/.zshrc`:

        fpath=(path/to/zsh-completions/src $fpath)

* You may have to force rebuild `zcompdump`:

        rm -f ~/.zcompdump; compinit

### Contributing

Contributions are welcome, see [CONTRIBUTING](https://github.com/zsh-users/zsh-completions/blob/master/CONTRIBUTING.md).


## License
Completions use the Zsh license, unless explicitly mentioned in the file header.
See [LICENSE](https://github.com/zsh-users/zsh-completions/blob/master/LICENSE) for more information.
