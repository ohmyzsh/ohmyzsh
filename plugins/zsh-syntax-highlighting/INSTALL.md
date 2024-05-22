How to install
--------------

### Using packages

First, install the package:

* Arch Linux: [community/zsh-syntax-highlighting][arch-package] / [AUR/zsh-syntax-highlighting-git][AUR-package]
* Debian: `zsh-syntax-highlighting` package [in `stretch`][debian-package] (or in [OBS repository][obs-repository])
* Fedora: [zsh-syntax-highlighting package][fedora-package-alt] in Fedora 24+ (or in [OBS repository][obs-repository])
* FreeBSD: `pkg install zsh-syntax-highlighting` (port name: [`shells/zsh-syntax-highlighting`][freebsd-port])
* Gentoo: [app-shells/zsh-syntax-highlighting][gentoo-repository]
* Mac OS X / Homebrew: `brew install zsh-syntax-highlighting` ([formula][brew-package])
* NetBSD: `pkg_add zsh-syntax-highlighting` (port name: [`shells/zsh-syntax-highlighting`][netbsd-port])
* OpenBSD: `pkg_add zsh-syntax-highlighting` (port name: [`shells/zsh-syntax-highlighting`][openbsd-port])
* openSUSE / SLE: `zsh-syntax-highlighting` package in [OBS repository][obs-repository]
* RHEL / CentOS / Scientific Linux: `zsh-syntax-highlighting` package in [OBS repository][obs-repository]
* Ubuntu: `zsh-syntax-highlighting` package [in Xenial][ubuntu-package] (or in [OBS repository][obs-repository])
* Void Linux: `zsh-syntax-highlighting package` [in XBPS][void-package]

[arch-package]: https://www.archlinux.org/packages/zsh-syntax-highlighting
[AUR-package]: https://aur.archlinux.org/packages/zsh-syntax-highlighting-git
[brew-package]: https://github.com/Homebrew/homebrew-core/blob/master/Formula/z/zsh-syntax-highlighting.rb
[debian-package]: https://packages.debian.org/zsh-syntax-highlighting
[fedora-package]: https://apps.fedoraproject.org/packages/zsh-syntax-highlighting
[fedora-package-alt]: https://bodhi.fedoraproject.org/updates/?packages=zsh-syntax-highlighting
[freebsd-port]: https://www.freshports.org/textproc/zsh-syntax-highlighting/
[gentoo-repository]: https://packages.gentoo.org/packages/app-shells/zsh-syntax-highlighting
[netbsd-port]: http://cvsweb.netbsd.org/bsdweb.cgi/pkgsrc/shells/zsh-syntax-highlighting/
[obs-repository]: https://software.opensuse.org/download.html?project=shells%3Azsh-users%3Azsh-syntax-highlighting&package=zsh-syntax-highlighting
[openbsd-port]: https://cvsweb.openbsd.org/ports/shells/zsh-syntax-highlighting/
[ubuntu-package]: https://launchpad.net/ubuntu/+source/zsh-syntax-highlighting
[void-package]: https://github.com/void-linux/void-packages/tree/master/srcpkgs/zsh-syntax-highlighting

See also [repology's cross-distro index](https://repology.org/metapackage/zsh-syntax-highlighting/versions)

Second, enable zsh-syntax-highlighting by sourcing the script. Running this command on the terminal will add the source line to the end of your .zshrc:

* On most Linux distributions (except perhaps NixOS):

    ```zsh
    echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
    ```

* NetBSD and OpenBSD:

    ```zsh
    echo "source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
    ```

* Mac OS X / Homebrew:

    ```zsh
    echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
    ```

Then restart zsh (such as by opening a new instance of your terminal emulator).

 Alternatively, add the `source` command manually **at the end** of your `.zshrc`:

* On most Linux distributions (except perhaps NixOS):
`source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh`
* NetBSD and OpenBSD:
`source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh`

Then restart zsh.

### In your ~/.zshrc

Simply clone this repository and source the script:

```zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
```

  Then, enable syntax highlighting in the current interactive shell:

```zsh
source ./zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
```

  If `git` is not installed, download and extract a snapshot of the latest
  development tree from:

```
https://github.com/zsh-users/zsh-syntax-highlighting/archive/master.tar.gz
```

  Note the `source` command must be **at the end** of `~/.zshrc`.


### With a plugin manager

Note that `zsh-syntax-highlighting` must be the last plugin sourced.

The zsh-syntax-highlighting authors recommend manual installation over the use
of a framework or plugin manager.

This list is incomplete as there are too many
[frameworks / plugin managers][framework-list] to list them all here.

[framework-list]: https://github.com/unixorn/awesome-zsh-plugins#frameworks

#### [Antigen](https://github.com/zsh-users/antigen)

Add `antigen bundle zsh-users/zsh-syntax-highlighting` as the last bundle in
your `.zshrc`.

#### [Fig](https://fig.io)

Click the `Install Plugin` button on the [Fig plugin page][fig-plugin].

[fig-plugin]: https://fig.io/plugins/other/zsh-syntax-highlighting

#### [Oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)

1. Clone this repository in oh-my-zsh's plugins directory:

    ```zsh
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    ```

2. Activate the plugin in `~/.zshrc`:

    ```zsh
    plugins=( [plugins...] zsh-syntax-highlighting)
    ```

3. Restart zsh (such as by opening a new instance of your terminal emulator).

#### [Prezto](https://github.com/sorin-ionescu/prezto)

Zsh-syntax-highlighting is included with Prezto. See the
[Prezto documentation][prezto-docs] to enable and configure highlighters.

[prezto-docs]: https://github.com/sorin-ionescu/prezto/tree/master/modules/syntax-highlighting

#### [zgen](https://github.com/tarjoilija/zgen)

Add `zgen load zsh-users/zsh-syntax-highlighting` to the end of your `.zshrc`.

#### [zinit](https://github.com/zdharma-continuum/zinit)

Add `zinit light zsh-users/zsh-syntax-highlighting` to the end of your
`.zshrc`.

#### [zplug](https://github.com/zplug/zplug)

Add `zplug "zsh-users/zsh-syntax-highlighting", defer:2` to your `.zshrc`.


### System-wide installation

Any of the above methods is suitable for a single-user installation,
which requires no special privileges.  If, however, you desire to install
zsh-syntax-highlighting system-wide, you may do so by running

```zsh
make install
```

and directing your users to add

```zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
```

to their `.zshrc`s.
