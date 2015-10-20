zsh-syntax-highlighting
=======================

**[Fish shell](http://www.fishshell.com) like syntax highlighting for [Zsh](http://www.zsh.org).**

*Requirements: zsh 4.3.17+.*


How to install
--------------

### Using packages

* Arch Linux: [community/zsh-syntax-highlighting](https://www.archlinux.org/packages/zsh-syntax-highlighting) / [AUR/zsh-syntax-highlighting-git](https://aur.archlinux.org/packages/zsh-syntax-highlighting-git)
* Gentoo: [mv overlay](http://gpo.zugaina.org/app-shells/zsh-syntax-highlighting)
* Mac OS X / Homebrew: [brew install zsh-syntax-highlighting](https://github.com/Homebrew/homebrew/blob/master/Library/Formula/zsh-syntax-highlighting.rb)

### In your ~/.zshrc

* Clone this repository:

        git clone git://github.com/zsh-users/zsh-syntax-highlighting.git

  (or [download a snapshot](https://github.com/zsh-users/zsh-syntax-highlighting/archive/master.tar.gz))

* Source the script **at the end** of `~/.zshrc`:

        source /path/to/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

* Source `~/.zshrc`  to take changes into account:

        source ~/.zshrc


### With oh-my-zsh

* Download the script or clone this repository in [oh-my-zsh](http://github.com/robbyrussell/oh-my-zsh) plugins directory:

        git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

* Activate the plugin in `~/.zshrc`:

        plugins=( [plugins...] zsh-syntax-highlighting)

* Source `~/.zshrc`  to take changes into account:

        source ~/.zshrc

Note that `zsh-syntax-highlighting` must be the last plugin sourced,
so make it the last element of the `$plugins` array.

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

Syntax highlighting is done by pluggable highlighter scripts, see the [highlighters directory](highlighters)
for documentation and configuration settings.
