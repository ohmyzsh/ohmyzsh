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

Simply clone this repository and source the script:

        git clone git://github.com/zsh-users/zsh-syntax-highlighting.git
        echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
        source ~/.zshrc

  If `git` is not installed, download and extract a snapshot of the latest
  development tree from:

        https://github.com/zsh-users/zsh-syntax-highlighting/archive/master.tar.gz

  Note the `source` command must be **at the end** of `~/.zshrc`.


### With oh-my-zsh

Oh-my-zsh is a zsh configuration framework.  It lives at
<http://github.com/robbyrussell/oh-my-zsh>.

To install zsh-syntax-highlighting under oh-my-zsh:

1. Clone this repository in oh-my-zsh's plugins directory:

        git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

2. Activate the plugin in `~/.zshrc`:

        plugins=( [plugins...] zsh-syntax-highlighting)

3. Source `~/.zshrc`  to take changes into account:

        source ~/.zshrc

Note that `zsh-syntax-highlighting` must be the last plugin sourced,
so make it the last element of the `$plugins` array.


### System-wide installation

Either of the above methods is suitable for a single-user installation,
which requires no special privileges.  If, however, you desire to install
zsh-syntax-highlighting system-wide, you may do so by running

    make install

and directing your users to add

    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

to their `.zshrc`s.



