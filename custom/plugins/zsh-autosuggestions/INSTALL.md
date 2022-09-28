# Installation

* [Packages](#packages)
* [Antigen](#antigen)
* [Oh My Zsh](#oh-my-zsh)
* [Manual](#manual-git-clone)

## Packages

| System  | Package |
| ------------- | ------------- |
| Debian / Ubuntu | [zsh-autosuggestions OBS repository](https://software.opensuse.org/download.html?project=shells%3Azsh-users%3Azsh-autosuggestions&package=zsh-autosuggestions) |
| Fedora / CentOS / RHEL / Scientific Linux | [zsh-autosuggestions OBS repository](https://software.opensuse.org/download.html?project=shells%3Azsh-users%3Azsh-autosuggestions&package=zsh-autosuggestions) |
| OpenSUSE / SLE | [zsh-autosuggestions OBS repository](https://software.opensuse.org/download.html?project=shells%3Azsh-users%3Azsh-autosuggestions&package=zsh-autosuggestions) |
| Arch Linux / Manjaro / Antergos / Hyperbola | [zsh-autosuggestions](https://www.archlinux.org/packages/zsh-autosuggestions), [zsh-autosuggestions-git](https://aur.archlinux.org/packages/zsh-autosuggestions-git) |
| NixOS | [zsh-autosuggestions](https://github.com/NixOS/nixpkgs/blob/master/pkgs/shells/zsh/zsh-autosuggestions/default.nix) |
| Void Linux | [zsh-autosuggestions](https://github.com/void-linux/void-packages/blob/master/srcpkgs/zsh-autosuggestions/template) |
| Mac OS | [homebrew](https://github.com/Homebrew/homebrew-core/blob/master/Formula/zsh-autosuggestions.rb)  |
| NetBSD | [pkgsrc](http://ftp.netbsd.org/pub/pkgsrc/current/pkgsrc/shells/zsh-autosuggestions/README.html)  |

## Antigen

1. Add the following to your `.zshrc`:

    ```sh
    antigen bundle zsh-users/zsh-autosuggestions
    ```

2. Start a new terminal session.

## Oh My Zsh

1. Clone this repository into `$ZSH_CUSTOM/plugins` (by default `~/.oh-my-zsh/custom/plugins`)

    ```sh
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    ```

2. Add the plugin to the list of plugins for Oh My Zsh to load (inside `~/.zshrc`):

    ```sh
    plugins=( 
        # other plugins...
        zsh-autosuggestions
    )
    ```

3. Start a new terminal session.

## Manual (Git Clone)

1. Clone this repository somewhere on your machine. This guide will assume `~/.zsh/zsh-autosuggestions`.

    ```sh
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
    ```

2. Add the following to your `.zshrc`:

    ```sh
    source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
    ```

3. Start a new terminal session.
