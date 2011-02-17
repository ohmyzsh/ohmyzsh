zsh-syntax-highlighting ![Project status](http://stillmaintained.com/nicoulaj/zsh-syntax-highlighting.png)
==========================================================================================================

**[Fish shell](http://www.fishshell.com) like syntax highlighting for [Zsh](http://www.zsh.org).**

*Requirements: zsh 4.3.9 or superior.*


## Try it

Here is a one-liner to try it without installing or modifying anything:

    wget --no-check-certificate --output-document=/tmp/zsh-syntax-highlighting.zsh https://github.com/nicoulaj/zsh-syntax-highlighting/raw/master/zsh-syntax-highlighting.zsh && . /tmp/zsh-syntax-highlighting.zsh


## Install it


### In your ~/.zshrc

* Download the script or clone this repository:

      git clone git://github.com/nicoulaj/zsh-syntax-highlighting.git

* Source the script **at the end** of `~/.zshrc`:

      source /path/to/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

* Source `~/.zshrc`  to take changes into account:

      source ~/.zshrc


### With oh-my-zsh

* Download the script or clone this repository in [oh-my-zsh](http://github.com/robbyrussell/oh-my-zsh) plugins directory:

      cd ~/.oh-my-zsh/plugins/
      git clone git://github.com/nicoulaj/zsh-syntax-highlighting.git

* Activate the plugin in `~/.zshrc` (in **last** position):

      plugins=( [plugins...] zsh-syntax-highlighting)

* Source `~/.zshrc`  to take changes into account:
    
      source ~/.zshrc


## Tweak it

Optionally, you can override the default styles used for highlighting. The styles are declared in the `ZSH_HIGHLIGHT_STYLES` array. You can override styles this way:

    # To differentiate aliases from other command types
    ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
    
    # To have paths colored instead of underlined
    ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
    
    # To disable highlighting of globbing expressions
    ZSH_HIGHLIGHT_STYLES[globbing]='none'

You can tweak the styles used to colorize matching brackets by overriding the `ZSH_HIGHLIGHT_MATCHING_BRACKETS_STYLES`.

    ZSH_HIGHLIGHT_MATCHING_BRACKETS_STYLES=(
      'fg=blue,bold'    # Style for first level of imbrication
      'fg=green,bold'   # Style for second level of imbrication
      'fg=magenta,bold' # etc... Put as many styles as you wish, or leave
      'fg=yellow,bold'  # empty to disable brackets matching.
      'fg=cyan,bold'
    )

This must be done **after** the script is sourced, otherwise your styles will be overwritten. The syntax for declaring styles is [documented here](http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#SEC135).
