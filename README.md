zsh-syntax-highlighting
=======================

[Fish shell](http://www.fishshell.org) like syntax highlighting for [Zsh](http://www.zsh.org).


## Try it

Here is a one-liner to try it without installing or modifying anything:

    wget --no-check-certificate --output-document=/tmp/zsh-syntax-highlighting.zsh https://github.com/nicoulaj/zsh-syntax-highlighting/raw/master/zsh-syntax-highlighting.zsh && . /tmp/zsh-syntax-highlighting.zsh


## Install it


### In your ~/.zshrc

* Download the script or clone this repository:

        git clone git://github.com/nicoulaj/zsh-syntax-highlighting.git

* Source the script at the end of `~/.zshrc`:

        source /path/to/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

* Source `~/.zshrc`  to take changes into account:

        source ~/.zshrc


### With oh-my-zsh

* Download the script or clone this repository in [oh-my-zsh](http://github.com/robbyrussell/oh-my-zsh) plugins directory:

        cd ~/.oh-my-zsh/plugins/
        git clone git://github.com/nicoulaj/zsh-syntax-highlighting.git
        cd zsh-syntax-highlighting
        ln -s zsh-syntax-highlighting.zsh zsh-syntax-highlighting.plugin.zsh

* Activate the plugin in `~/.zshrc`

        plugins=(zsh-syntax-highlighting)

* Source `~/.zshrc`  to take changes into account:
    
        source ~/.zshrc


## Tweak it

Optionally, you can override the default styles used for highlighting. The styles are declared in the [`ZSH_HIGHLIGHT_STYLES` array](https://github.com/nicoulaj/zsh-syntax-highlighting/blob/master/zsh-syntax-highlighting.zsh#L9). You can override styles this way:

    # To differenciate aliases from other command types
    ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
    
    # To have paths colored instead of underlined
    ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
    
    # To disable highlighting of globbing expressions
    ZSH_HIGHLIGHT_STYLES[globbing]='none'

This must be done **after** the script is sourced, otherwise your styles will be overwritten. The syntax for declaring styles is [documented here](http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#SEC135).


## Authors / Greetings

 * [Roy Zuo](https://github.com/roylez)
 * [Julien Nicoulaud](https://github.com/nicoulaj)
 * [Dave Ingram](https://github.com/dingram)
 * [Mounier Florian](https://github.com/paradoxxxzero)
 * [Jonathan Dahan](https://github.com/jedahan)
 * James Ahlborn
 * [Andreas Jaggi](https://github.com/x-way)
 * [Wayne Davison](https://github.com/WayneD)
 * [Suraj N. Kurapati](https://github.com/sunaku)
 * [Takeshi Banse](https://github.com/hchbaw)
