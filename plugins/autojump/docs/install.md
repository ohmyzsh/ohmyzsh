## INSTALLATION

### REQUIREMENTS

- Python v2.6+ or Python v3.3+
- Supported shells
    - bash  - first class support
    - zsh - first class support
    - fish - community supported
    - tcsh - community supported
    - clink - community supported
- Supported platforms
    - Linux - first class support
    - OS X - first class support
    - Windows - community supported
    - BSD - community supported
- Supported installation methods
    - source code - first class support
    - Debian and derivatives - first class support
    - ArchLinux / Gentoo / openSUSE / RedHat and derivatives - community supported
    - Homebrew / MacPorts - community supported

Due to limited time and resources, only "first class support" items will be
maintained by the primary committers. All "community supported" items will be
updated based on pull requests submitted by the general public.

Please continue opening issues and providing feedback for community supported
items since consolidating information helps other users troubleshoot and submit
enhancements and fixes.

### MANUAL

Grab a copy of autojump:

    git clone git://github.com/wting/autojump.git

Run the installation script and follow on screen instructions.

    cd autojump
    ./install.py or ./uninstall.py

### AUTOMATIC

#### Linux

autojump is included in the following distro repositories, please use relevant
package management utilities to install (e.g. apt-get, yum, pacman, etc):

- Debian, Ubuntu, Linux Mint

    All Debian-derived distros require manual activation for policy reasons,
    please see `/usr/share/doc/autojump/README.Debian`.

- RedHat, Fedora, CentOS

    Install `autojump-zsh` for zsh, `autojump-fish` for fish, etc.

- ArchLinux
- Gentoo
- Frugalware
- Slackware

#### OS X

Homebrew is the recommended installation method for Mac OS X:

    brew install autojump

MacPorts is also available:

    port install autojump

## Windows

Windows support is enabled by [clink](https://mridgers.github.io/clink/) which
should be installed prior to installing autojump.
