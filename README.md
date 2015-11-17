zsh-syntax-highlighting
=======================

**[Fish shell](http://www.fishshell.com) like syntax highlighting for Zsh.**

*Requirements: zsh 4.3.17+.*

This package provides syntax highlighing for the shell zsh.  It enables
highlighing of commands whilst they are typed at a zsh prompt into an
interactive terminal.  This helps in reviewing commands before running
them, particularly in catching syntax errors.

[![Screenshot](images/preview-smaller.png)](images/preview.png)


How to install
--------------

### Using packages

* Arch Linux: [community/zsh-syntax-highlighting][arch-package] / [AUR/zsh-syntax-highlighting-git][AUR-package]
* Gentoo: [mv overlay][gentoo-overlay]
* Mac OS X / Homebrew: [brew install zsh-syntax-highlighting][brew-package]

[arch-package]: https://www.archlinux.org/packages/zsh-syntax-highlighting
[AUR-package]: https://aur.archlinux.org/packages/zsh-syntax-highlighting-git
[gentoo-overlay]: http://gpo.zugaina.org/app-shells/zsh-syntax-highlighting
[brew-package]: https://github.com/Homebrew/homebrew/blob/master/Library/Formula/zsh-syntax-highlighting.rb


### In your ~/.zshrc

* Clone this repository:

        git clone git://github.com/zsh-users/zsh-syntax-highlighting.git

  If `git` is not installed, you could download a snapshot of the latest
  development tree from:

        https://github.com/zsh-users/zsh-syntax-highlighting/archive/master.tar.gz

* Source the script **at the end** of `~/.zshrc`:

        source /path/to/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

* Source `~/.zshrc`  to take changes into account:

        source ~/.zshrc


### With oh-my-zsh

Oh-my-zsh is a zsh configuration framework.  It lives at
<http://github.com/robbyrussell/oh-my-zsh>.

To install zsh-syntax-highlighting under oh-my-zsh:

1. Download the script or clone this repository in oh-my-zsh's plugins directory:

        git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

2. Activate the plugin in `~/.zshrc`:

        plugins=( [plugins...] zsh-syntax-highlighting)

3. Source `~/.zshrc`  to take changes into account:

        source ~/.zshrc

Note that `zsh-syntax-highlighting` must be the last plugin sourced,
so make it the last element of the `$plugins` array.


### System-wide installation

Either of the above methods is suitable for a single-user installation, which requires
no special privileges.  If, however, you desire to install zsh-syntax-highlighting
system-wide, you may do so by running `make install` and directing your users to
add `source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh`
in their `.zshrc`s.


FAQ
---

### Why must `zsh-syntax-highlighting.zsh` be sourced at the end of the `.zshrc` file?

`zsh-syntax-highlighting.zsh` wraps ZLE widgets.  It must be sourced after all
custom widgets have been created (i.e., after all `zle -N` calls and after
running `compinit`).  Widgets created later will work, but will not update the
syntax highlighting.

### How are new releases announced?

There is currently no "push" announcements channel.  However, the following alternatives exist:

- GitHub's RSS feed of releases: https://github.com/zsh-users/zsh-syntax-highlighting/releases.atom
- An anitya entry: https://release-monitoring.org/project/7552/


How to tweak
------------

Syntax highlighting is done by pluggable highlighter scripts.  See the
[`highlighters` directory](./highlighters) for documentation and configuration
settings.
