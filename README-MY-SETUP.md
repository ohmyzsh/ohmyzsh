My Shell Setup
==============

Much if my information comes from [here](https://www.bretfisher.com/shell/) and his [YouTube video](https://www.youtube.com/watch?v=KeSIJQEinJA).

Note that this will backup and replace your existing `~/.zshrc` file

You'll need zsh to install Oh My Zsh. Run `zsh --version` to check if you have it.

macOS
-----

* install [HomeBrew](https://brew.sh/) (probably already installed)
* install [iTerm2](https://www.iterm2.com/)
* install prereqs
  * need to install [Nerd Fonts](https://www.nerdfonts.com) (may want other fonts but must be `Nerd` variety)

    ```shell
    brew tap homebrew/cask-fonts
    brew install --cask font-fantasque-sans-mono
    brew install --cask font-hack-nerd-font
    brew install --cask font-fira-nerd-font
    ```

  * Configure iTerm2 to use one of the nerd fonts
  * needed for `oh-my-zsh` module `autojump`

    ```shell
    brew install autojump
    brew install terminal-notifier
    ```

  * install `ls` replacement `exa`

    ```shell
    brew install exa
    ```

* continue to [Common Install Steps](#common-install-steps)

Linux
-----

* install [Tilex](https://gnunn1.github.io/tilix-web/)

  ```shell
  apt install tilix
  ```

* install prereqs
  * If which zsh not installed, then install with `sudo apt install zsh`. Next, change your login shell with `chsh -s $(which zsh)`

  * need to install [Nerd Fonts](https://www.nerdfonts.com) (may want other fonts but must be `Nerd` variety)
    * I download [FiraCode](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/FiraCode.zip), exand, open Nautilus and double-click on each non-Windows font
  * configure Tilix to use the Nerd font
  * install `autojump`

    ```(shell)
    sudo apt install autojump
    ```

* continue to [Common Install Steps](#common-install-steps)

Windows
-------

* Install [Windows Terminal](https://github.com/microsoft/terminal)
* Recommend using WSL2 with Ubuntu and zsh installed there, but may be able to use Git Bash
* other steps TBD
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
      sh -c "$(curl -fsSL <https://raw.githubusercontent.com/fklassen/ohmyzsh/master/tools/install.sh>)"
      ```

    * if you forked your own repo ...

      ```shell
      REPO=<your_github_id>/ohmyzsh sh -c "$(curl -fsSL <https://raw.githubusercontent.com/fklassen/ohmyzsh/master/tools/install.sh>)"
      ```

  * optionally configure by editing '~/.zshrc` (see [Getting Started](https://github.com/ohmyzsh/ohmyzsh/wiki#getting-started))
    * I personally like to make a symbolic link so I can commit my changes to my forked config

      ```(shell)
      cd
      ln -sf ~/.oh-my-zsh/templates/zshrc.zsh-template .zshrc
      ```

* install [Starship](https://starship.rs)
  * run installer

    ```(shell)
    curl -sS https://starship.rs/install.sh | sh
    ```

  * take a copy Starship config file

    ```(shell)
    mkdir -p ~/.config
    cd ~/.config
    ln -s ~/.oh-my-zsh/templates/starship.toml
    ```

* Start a terminal session

Post install
------------

There are a few things that can make things even better

* set up GIT configuration
  * `cd && ln -s ~/.oh-my-zsh/plugins/gitconfig .gitconfig`
  * create a `~/.gitconfig.user` for user-specific GIT settings

    ```(shell)
    [user]
      name = Fred Klassen
      email = fred.klassen@broadcom.com
      #email = fklassen@appneta.com
      signingkey = 84E4FA215C934A7D97DC76D5E9E2149793BDE17E
    ```

* create ~/.inputrc

  ```(shell)
  set editing-mode vi
  set bell-style none
  ```

* install tmux config [Oh My Tmux](https://github.com/gpakosz/.tmux)
* install vim config [SpaceVim](https://spacevim.org/)
* install Mosh replacement [Eternal Terminal](https://eternalterminal.dev/)
* on macOS
  * install macVIM via `brew install macvim`
  * install some colour themes for iTerm2 that you can choose from
    * [iTerm2 snazzy](https://github.com/sindresorhus/iterm2-snazzy)
    * [GitHub VS Code Theme for iTerm](https://github.com/cdalvaro/github-vscode-theme-iterm)
