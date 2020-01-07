<p align="center">
  <img src="https://s3.amazonaws.com/ohmyzsh/oh-my-zsh-logo.png" alt="Oh My Zsh">
</p>

Oh My Zsh is an open source, community-driven framework for managing your [zsh](https://www.zsh.org/) configuration.

Sounds boring. Let's try again.

__Oh My Zsh will not make you a 10x developer...but you may feel like one.__

Once installed, your terminal shell will become the talk of the town _or your money back!_ With each keystroke in your command prompt, you'll take advantage of the hundreds of powerful plugins and beautiful themes. Strangers will come up to you in cafés and ask you, _"that is amazing! are you some sort of genius?"_

Finally, you'll begin to get the sort of attention that you have always felt you deserved. ...or maybe you'll use the time that you're saving to start flossing more often. 😬

To learn more, visit [ohmyz.sh](https://ohmyz.sh), follow [@ohmyzsh](https://twitter.com/ohmyzsh) on Twitter, and/or join us on Discord.

[![Follow @ohmyzsh](https://img.shields.io/twitter/follow/ohmyzsh?label=Follow+@ohmyzsh&style=flat)](https://twitter.com/intent/follow?screen_name=ohmyzsh)
[![Discord server](https://img.shields.io/discord/642496866407284746)](https://discord.gg/bpXWhnN)

## Getting Started

### Prerequisites

* A Unix-like operating system: macOS, Linux, BSD. On Windows: WSL is preferred, but cygwin or msys also mostly work.
* [Zsh](https://www.zsh.org) should be installed (v4.3.9 or more recent). If not pre-installed (run `zsh --version` to confirm), check the following instructions here: [Installing ZSH](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
* `git` should be installed

#### Installation

##### 1. Clone the repository + submodules:

```shell
git clone --recurse-submodules https://github.com/vavalm/ohmyzsh.git ~/.oh-my-zsh
```

##### 2. take existing `~/.zshrc` file:

```shell
cp ~/.oh-my-zsh/custom.zshrc ~/.zshrc
```

##### 3. Change your default shell

```shell
chsh -s $(which zsh)
```

### Uninstalling Oh My Zsh

Oh My Zsh isn't for everyone. We'll miss you, but we want to make this an easy breakup.

If you want to uninstall `oh-my-zsh`, just run `uninstall_oh_my_zsh` from the command-line. It will remove itself and revert your previous `bash` or `zsh` configuration.

### More information

Take a look on the initial [zsh repository](https://github.com/ohmyzsh/ohmyzsh)

## License

Oh My Zsh is released under the [MIT license](LICENSE.txt).

## About Planet Argon

![Planet Argon](https://pa-github-assets.s3.amazonaws.com/PARGON_logo_digital_COL-small.jpg)

Oh My Zsh was started by the team at [Planet Argon](https://www.planetargon.com/?utm_source=github), a [Ruby on Rails development agency](https://www.planetargon.com/skills/ruby-on-rails-development?utm_source=github). Check out our [other open source projects](https://www.planetargon.com/open-source?utm_source=github).
