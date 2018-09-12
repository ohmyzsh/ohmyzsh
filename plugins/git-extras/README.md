# git-extras

This plugin provides completion definitions for some of the commands defined by [git-extras](https://github.com/tj/git-extras).

##  Setup notes

The completions work by augmenting the `_git` completion provided by `zsh`. This only works with the `zsh`-provided `_git`, not the `_git` provided by `git` itself. If you have both `zsh` and `git` installed, you need to make sure that the `zsh`-provided `_git` takes precedence.

### OS X Homebrew Setup

On OS X with Homebrew, you need to install `git` with `brew install git --without-completions`. Otherwise, `git`'s `_git` will take precedence, and you won't see the completions for `git-extras` commands.
