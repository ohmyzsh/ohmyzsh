[![k.rimraf.com](https://raw.githubusercontent.com/supercrabtree/k/gh-pages/k-logo.png)](http://k.rimraf.com)

> k is the new l, yo

## Directory listings for zsh with git features

**k** is a zsh script / plugin to make directory listings more readable, adding a bit of color and some git status information on files and directories.

### Git status on entire repos
![Repository git status](https://raw.githubusercontent.com/supercrabtree/k/gh-pages/repo-dirs.jpg)


### Git status on files within a working tree
![Repository work tree git status](https://raw.githubusercontent.com/supercrabtree/k/gh-pages/inside-work-tree.jpg)

### File weight colours
Files sizes are graded from green for small (< 1k), to red for huge (> 1mb).

**Human readable files sizes**  
Human readable files sizes can be shown by using the `-h` flag, which requires the `numfmt` command to be available. OS X / Darwin does not have a `numfmt` command by default, so GNU coreutils needs to be installed, which provides `gnumfmt` that `k` will also use if available. GNU coreutils can be installed on OS X with [homebrew](http://brew.sh):

```
brew install coreutils
```

![File weight colours](https://raw.githubusercontent.com/supercrabtree/k/gh-pages/file-size-colors.jpg)


### Rotting dates
Dates fade with age.  

![Rotting dates](https://raw.githubusercontent.com/supercrabtree/k/gh-pages/dates.jpg)


## Installation

### Using [Antigen](https://github.com/zsh-users/antigen)

Include the bundle in your `.zshrc`

```shell
antigen bundle rimraf/k
antigen apply
```

### Using [zgen](https://github.com/tarjoilija/zgen)

Include the load command in your `.zshrc`

```shell
zgen load rimraf/k
zgen save
```

### Manually
Put `k.sh` somewhere, and source it in your `.zshrc`.

```shell
source ~/path-to/k/k.sh
```

## Usage
Hit k in your shell

```shell
k
```

## Minimum Requirements
zsh 4.3.11  
Git 1.7.2

## Contributers
Pull requests welcome.  
[supercrabtree](https://github.com/supercrabtree) 56  
[chrstphrknwtn](https://github.com/chrstphrknwtn) 44  
[zirrostig](https://github.com/zirrostig) 19  
[lejeunerenard](https://github.com/lejeunerenard) 2  
[george-b](https://github.com/george-b) 1  
[pixcrabtree](https://github.com/pixcrabtree) 1  
[jozefizso](https://github.com/jozefizso) 1  
[philpennock](https://github.com/philpennock) 1  
[hoelzro](https://github.com/hoelzro) 1  
[srijanshetty](https://github.com/srijanshetty) 1  
[mattboll](https://github.com/mattboll) 1  

We'd like to make this POSIX compliant so that it can be used with bash and other shells. But don't really know anything about shell scripting, so if you think you could help that would be coooool :)

## Thanks
[Paul Falstad](http://www.falstad.com/) for zsh  
[Robby Russell](https://github.com/robbyrussell) for making the shell fun with oh my zsh  
[Sindre Sorhus](https://github.com/sindresorhus) for fast git commands from zsh pure theme  
[Rupa](https://github.com/rupa/z) for that slammin' strapline  

Copyright © 2015 George Crabtree & Christopher Newton. MIT License.
