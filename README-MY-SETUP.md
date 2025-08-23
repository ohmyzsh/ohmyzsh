My Shell Setup
==============

Much of my information comes from [here](https://www.bretfisher.com/shell/) and his [YouTube video](https://www.youtube.com/watch?v=KeSIJQEinJA).

Note that this will backup and replace your existing `~/.zshrc` file

You'll need zsh to install Oh My Zsh. Run `zsh --version` to check if you have it.

macOS
-----

* install [HomeBrew](https://brew.sh/) (probably already installed)
* install [iTerm2](https://www.iterm2.com/)
* install/configure iTerm2 colour themes [Grove Box contrib](https://github.com/gruvbox-community/gruvbox-contrib)
* install prereqs
  * need to install [Nerd Fonts](https://www.nerdfonts.com) (may want other fonts but must be `Nerd` variety)

    ```shell
    brew tap homebrew/cask-fonts
    brew install --cask font-meslo-lg-nerd-font
    brew install --cask font-hack-nerd-font
    brew install --cask font-fira-nerd-font
    ```

  * Configure iTerm2 to use one of the nerd fonts (I like hack)
  * needed for `oh-my-zsh` module `fasd`

    ```shell
    brew install fasd
    brew install terminal-notifier
    brew install thefuck
    ```

  * install `ls` replacement `exa`

    ```shell
    brew install exa
    ```

  * and/or install `ls` replacement `lsd`

    ```shell
    brew install lsd
    ```

* continue to [Common Install Steps](#common-install-steps)

Linux
-----

* install some terminal tools

  ```(shell)
  sudo apt install curl lsd fasd fzf ruby-full thefuck tmux vim-nox git
  ```

* install [Tilex](https://gnunn1.github.io/tilix-web/)

  ```shell
  sudo apt install tilix
  ```

* install/configure Tilex colour themes [Grove Box for Tilix](https://github.com/MichaelThessel/tilix-gruvbox)
* install prereqs
  * If which zsh not installed, then install with `sudo apt install zsh`. Next, change your login shell with `chsh -s $(which zsh)`

  * need to install [Nerd Fonts](https://www.nerdfonts.com) (may want other fonts but must be `Nerd` variety)
    * I download, expand, open Nautilus and double-click on each non-Windows font
      * [Hack](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Hack.zip)
      * [FiraCode](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/FiraCode.zip)
      * [Meslo](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Meslo.zip)
  * configure Tilix to use the Nerd font (I like Hack)

* continue to [Common Install Steps](#common-install-steps)

Windows
-------

* Install [Git Bash](https://www.atlassian.com/git/tutorials/git-bash), if not already installed
* Optionally install Windows Terminal
  * from an Admin PowerShell: `choco install microsoft-windows-terminal`
  * add [Git Bash to Windows Terminal](https://linuxhint.com/add-git-bash-windows-terminal/)
* Install _Zsh_ (not oh-my-zsh) using [these instructions](https://dominikrys.com/posts/zsh-in-git-bash-on-windows/)
  * you may need to download [PeaZip](https://peazip.github.io/zst-compressed-file-format.html) to extract the file
  * once .zst is extracted and copied to `/c/Program\ Files/Git/` open an admin Git Bash and do ...

    ```(shell)
    fklassen@FREDKLASSENA265 MINGW64 ~
    $ cd /
    fklassen@FREDKLASSENA265 MINGW64 /
    $ tar xvf zsh-5.9-2-x86_64.pkg.tar
    ```

  * for `.bashrc` I prefer to append this entry so I can start the bash shell from zsh

    ```(shell)
    /c/Windows/System32/chcp.com 65001 > /dev/null 2>&1
    if [ -t 1 ] && [ "$0" = "/usr/bin/bash" ]; then
      exec zsh
    fi
    ```

  * install [fasd]()
    * `git clone https://github.com/clvv/fasd.git`
    * open and Git Bash terminal in Administrator mode, cd to above directy and
      * `make install`
  * continue with instructions to install Zsh
* install Oh My Posh in a PowerShell with commands:
  * `winget install oh-my-posh`
  * `winget install XP8K0HKJFRXGCK`
  * `winget upgrade oh-my-posh`
* need to install [Nerd Fonts](https://www.nerdfonts.com) (may want other fonts but must be `Nerd` variety)
  * I download, expand, open with Explorer and double-click on each Windows font
    * [Hack](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Hack.zip)
    * [FiraCode](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/FiraCode.zip)
    * [Meslo](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Meslo.zip)
* Windows Terminal does not seem to accept Nerd Fonts so I updated fonts in Git Bash shortcut and mainly use that.
* continue to [Common Install Steps](#common-install-steps)

Common Install Steps
--------------------

* install [Oh My Zsh](https://ohmyz.sh/) customized [fork](https://github.com/fklassen/ohmyzsh)
  * fork `fklassen` fork of `oh-my-zsh` to your personal account, or simpler yet use `fklassen/ohmyzsh` if you don't plan to modify anything

    ```shell
    https://github.com/fklassen/ohmyzsh/fork
    ```

  * if you forked, optionally modify `README.md` and `tools/install.sh` to point to your repo so that you don't need `REPO=fklassen/ohmyzsh` during installation
  * optionally customize forked repo to match your preferences
  * run installer
    * if you are using `fklassen/ohmyzsh` ...

      ```shell
      `sh -c "$(curl -fsSL https://raw.githubusercontent.com/fklassen/ohmyzsh/master/tools/install.sh)"`
      ```

    * if you forked your own repo ...

      ```shell
      REPO=<your_github_id>/ohmyzsh sh -c "$(curl -fsSL <https://raw.githubusercontent.com/fklassen/ohmyzsh/master/tools/install.sh>)"
      ```

    * initialize submodules

      ```(shell)
      cd ~/.oh-my-zsh
      git submodules update --init
      ```

  * ... or if that doesn't work simply `git clone --recurse-submodules https://github.com/fklassen/ohmyzsh.git`
  * configure '~/.zshrc` (see [Getting Started](https://github.com/ohmyzsh/ohmyzsh/wiki#getting-started))
    * I personally like to make a symbolic link so I can commit my changes to my forked config

      ```(shell)
      cd
      ln -sf ~/.oh-my-zsh/templates/zshrc.zsh-template .zshrc
      ```

* install [Starship](https://starship.rs)
  * copy or link Starship config file

    ```(shell)
    mkdir -p ~/.config
    cd ~/.config
    ln -s ~/.oh-my-zsh/templates/starship.toml
    ```

  * run installer

    ```(shell)
    curl -sS https://starship.rs/install.sh | sh
    ```

* install [fzf](https://github.com/junegunn/fzf#installation) for [zsh-interactive-cd](https://github.com/fklassen/ohmyzsh/tree/master/plugins/zsh-interactive-cd) support
* Start a terminal session

Post install
------------

There are a few things that can make things even better

* set up GIT configuration
  * `cd && ln -s ~/.oh-my-zsh/template/gitconfig .gitconfig`
  * create a `~/.gitconfig.user` for user-specific GIT settings

    ```(shell)
    [user]
      name = Fred Klassen
      email = fred.klassen@broadcom.com
      #email = fklassen@appneta.com
      signingkey = 84E4FA215C934A7D97DC76D5E9E2149793BDE17E
    ```

* create ~/.inputrc
  * `cd && ln -s ~/.oh-my-zsh/template/inputrc .inputrc`
* if tmux is installed install tmux config [Oh My Tmux](https://github.com/gpakosz/.tmux)
* install vim config [SpaceVim](https://spacevim.org/)
* install Mosh replacement [Eternal Terminal](https://eternalterminal.dev/)
* optionally install [lsd](https://github.com/Peltoche/lsd)
* optionally install file transer app
  * `curl -sL https://cutt.ly/tran-cli | bash`
* on macOS
  * install macVIM via `brew install macvim`
  * if you don't like Gruv Box, you may want to install some colour themes for iTerm2
    * [iTerm2 snazzy](https://github.com/sindresorhus/iterm2-snazzy)
    * [GitHub VS Code Theme for iTerm](https://github.com/cdalvaro/github-vscode-theme-iterm)
