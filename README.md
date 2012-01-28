# Oh My Zsh

OMZ is a configuration framework for [Zsh](http://www.zsh.org) that enriches
the command line interface environment with sane defaults, aliases, functions,
auto completion, and prompt themes.

## Installation

Oh My Zsh will work with any recent release of Zsh, but the minimum recommended
version is 4.3.10.

1. Clone the repository:

    `git clone https://github.com/sorin-ionescu/oh-my-zsh.git ~/.oh-my-zsh`

2. Initialize the submodules:

    `git submodule update --init --recursive`

3. Create a new Zsh configuration by copying the Zsh template provided:

    `cp ~/.oh-my-zsh/templates/zshrc.zsh ~/.zshrc`

4. Set Zsh as your default shell:

    `chsh -s /bin/zsh`

5. Open a new Zsh terminal window or tab.

### Mac OS X

If you have administrator privileges, you must fix an Apple miss configuration
in Mac OS X 10.7 Lion by renaming `/etc/zshenv` to `/etc/zprofile`, or Zsh will
have the wrong `PATH` when executed non-interactively by scripts.

### Troubleshooting

If you are not able to find certain commands after switching to *Oh My Zsh*,
modify the `PATH` variable in `environment.zsh` then open a new Zsh terminal
window or tab.

## Usage

Oh My Zsh has many features disabled by default. Read the source code and
accompanying README files to learn of what is available.

### Plugins

1. Browse `plugins/` to see what is available.
2. Load the plugins you need in `~/.zshrc` then open a new Zsh terminal window
   or tab.

### Themes

1. For a list of themes, type `prompt -l`.
2. To preview a theme, type `prompt -p name`.
3. Load the theme you like in `~/.zshrc` then open a new Zsh terminal window or
   tab.
   ![sorin theme](http://i.imgur.com/aipDQ.png "sorin theme")

## Customization

The project is managed via [Git](http://git-scm.com). It is highly recommend
that you commit your changes and push them to [GitHub](http://github.com) to
not lose them. If you do not know how to use Git, follow this
[tutorial](http://gitimmersion.com) and bookmark this
[reference](http://gitref.org).

### Completions

Submit program completions to the
[zsh-completions](https://github.com/zsh-users/zsh-completions) project. The Oh
My Zsh completions directory will be synched against it.

## Resources

The [Zsh Reference Card](http://www.bash2zsh.com/zsh_refcard/refcard.pdf) is
indispensable.

## Contribute

This project would not exist without all of its users and
[contributors](https://github.com/sorin-ionescu/oh-my-zsh/contributors).

If you have ideas on how to make the configuration easier to maintain or
improve its performance, do not hesitate to fork and send pull requests.

## License

(The MIT License)

Copyright (c) 2009-2012 Robby Russell, Sorin Ionescu, and contributors.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

