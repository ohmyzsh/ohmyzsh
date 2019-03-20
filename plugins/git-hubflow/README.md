# git-hubflow plugin

This plugin adds completion for [HubFlow](https://datasift.github.io/gitflow/) (GitFlow for GitHub), as well as some
aliases for common commands. HubFlow is a git extension to make it easy to use GitFlow with GitHub. Based on the
original gitflow extension for git.

The hubflow tool has to be [installed](https://github.com/datasift/gitflow#installation) separately.

To use it, add `git-hubflow` to the plugins array in your zshrc file:

```zsh
plugins=(... git-hubflow)
```

## Aliases

| Alias | Command          | Description                                                      |
|-------|------------------|------------------------------------------------------------------|
| ghf   | `git hf`         | Print command overview                                           |
| ghff  | `git hf feature` | Manage your feature branches                                     |
| ghfr  | `git hf release` | Manage your release branches                                     |
| ghfh  | `git hf hotfix`  | Manage your hotfix branches                                      |
| ghfs  | `git hf support` | Manage your support branches                                     |
| ghfu  | `git hf update`  | Pull upstream changes down into your master and develop branches |
