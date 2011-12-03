zsh-syntax-highlighting
=======================

**[Fish shell](http://www.fishshell.com) like syntax highlighting for [Zsh](http://www.zsh.org).**

*Requirements: zsh 4.3.9+.*


How to install
--------------

### Using packages

* Arch Linux: [AUR/zsh-syntax-highlighting](https://aur.archlinux.org/packages.php?ID=54171) / [AUR/zsh-syntax-highlighting-git](https://aur.archlinux.org/packages.php?ID=50867)
* Gentoo: [mv overlay](http://gpo.zugaina.org/app-shells/zsh-syntax-highlighting)

### In your ~/.zshrc

* Download the script or clone this repository:

        git clone git://github.com/zsh-users/zsh-syntax-highlighting.git

* Source the script **at the end** of `~/.zshrc`:

        source /path/to/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

* Source `~/.zshrc`  to take changes into account:

        source ~/.zshrc


### With oh-my-zsh

* Download the script or clone this repository in [oh-my-zsh](http://github.com/robbyrussell/oh-my-zsh) plugins directory:

        cd ~/.oh-my-zsh/custom/plugins
        git clone git://github.com/zsh-users/zsh-syntax-highlighting.git

* Activate the plugin in `~/.zshrc` (in **last** position):

        plugins=( [plugins...] zsh-syntax-highlighting)

* Source `~/.zshrc`  to take changes into account:
    
        source ~/.zshrc


How to tweak
------------

Syntax highlighting is done by pluggable highlighter scripts, see the [highlighters directory](zsh-syntax-highlighting/tree/master/highlighters)
for documentation and configuration settings.
