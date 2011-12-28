A handful of functions, auto-complete helpers, and stuff that makes you shout...

> “OH MY ZSHELL!”

## Setup

`oh-my-zsh` should work with any recent release of [Zsh](http://www.zsh.org), but the
minimum recommended version is 4.3.9.

1. Clone the repository.

    `git clone git://github.com/sorin-ionescu/oh-my-zsh.git ~/.oh-my-zsh`

2. Create a new Zsh configuration by copying the Zsh template provided.

**NOTE**: If you already have a `~/.zshrc` file, you should back it up with `cp
~/.zshrc{,.orig}` in case you want to go back to your original settings.

    cp ~/.oh-my-zsh/templates/zshrc.template.zsh ~/.zshrc

3. Set Zsh as your default shell:

    `chsh -s /bin/zsh`

4. Start / restart Zsh by opening a new terminal window or tab.

### Problems?

If you are not able to find certain commands after switching to *Oh My Zsh*, you need
to modify `PATH` in `~/.zshrc`, or better yet, in `~/functions/02.environment.zsh`
(may be subject to merge conflicts).

## Usage

- Enable the plugins you want in `~/.zshrc`.
    - Browse `plugins/` to see what is available.
    - Populate the plugins array `plugins=(git osx ruby)`.

- Change the prompt in `~/.zshrc`.
    - For a list of themes, type `prompt -l`.
    - To preview a theme, type `prompt -p name`.

## Useful

The [Zsh Reference Card](http://www.bash2zsh.com/zsh_refcard/refcard.pdf) is tasty.

### Customization

If you have many related functions, you can organise them in a file in the
`functions/` directory.

## Help out!

I am not a Zsh expert and suspect that there are improvements to be made. If you have
ideas on how to make the configuration easier to maintain or improve the performance,
do not hesitate to fork and send pull requests!

## Contributors

This project would not exist without all of our awesome users and contributors.

- View the growing [list](https://github.com/robbyrussell/oh-my-zsh/contributors) of
  contributors.

Thank you so much!

## License

(The MIT License)

Copyright (c) 2011 Robby Russell, Sorin Ionescu, and contributors.

Permission is hereby granted, free of charge, to any person obtaining a copy of this
software and associated documentation files (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy, modify,
merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be included in all copies
or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR
A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

