# git-flow (AVH Edition) plugin

This plugin adds completion for the [git-flow (AVH Edition)](https://github.com/petervanderdoes/gitflow-avh).
The AVH Edition of the git extensions that provides high-level repository operations for [Vincent Driessen's branching model](https://nvie.com/posts/a-successful-git-branching-model/).

To use it, add `git-flow-avh` to the plugins array in your zshrc file:

```zsh
plugins=(... git-flow-avh)
```

## Requirements

1. The git-flow tool has to be [installed](https://github.com/petervanderdoes/gitflow-avh#installing-git-flow)
   separately.

2. You have to use zsh's git completion instead of the git project's git completion. This is typically
   done by default so you don't need to do anything else. If you installed git with Homebrew you
   might have to uninstall the git completion it's bundled with.
