# git-extras

This plugin provides completion definitions for some of the commands defined by [git-extras](https://github.com/tj/git-extras), which must already be installed.

To use it, add `git-extras` to the plugins array in your zshrc file:

```zsh
plugins=(... git-extras)
```

## Setup notes

The completions work by augmenting the `_git` completion provided by `zsh`. This only works with the `zsh`-provided `_git`, not the `_git` provided by `git` itself. If you have both `zsh` and `git` installed, you need to make sure that the `zsh` provided `_git` takes precedence.

To find out where the `_git` completions are installed and which one has precedence:

1. `ls /usr/share/zsh/functions/Completion/Unix/_git` # if present, the `zsh` provided `_git` completion is present.
2. `ls /usr/share/git/completion/git-completion.zsh`  # if present, the `git` provided `_git` completion is present. And why wouldn't it be?
3. `which _git` # will show the path of the _git completion that is currently being used by your shell, indicating which one has precedence.

### OS X Homebrew Setup

**NOTE:** this no longer works on current Homebrew distributions of git. ~~On OS X with Homebrew, you need to install `git` with `brew install git --without-completions`. Otherwise, `git`'s `_git` will take precedence, and you won't see the completions for `git-extras` commands.~~
