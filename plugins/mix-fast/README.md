# mix-fast

Fast mix autocompletion plugin.

This script caches the output for later usage and significantly speeds it up.
It generates a .mix_tasks cache file for current project. Currently if you want
to update cache you should remove .mix_tasks file

Inspired by and based on rake-fast zsh plugin.

This is entirely based on [this pull request by Ullrich Schäfer](https://github.com/robb/.dotfiles/pull/10/), which is inspired by [this Ruby on Rails trick from 2006](https://weblog.rubyonrails.org/2006/3/9/fast-rake-task-completion-for-zsh/).


## Installation

Just add the plugin to your `.zshrc`:

```bash
plugins=(foo bar mix-fast)
```

You might consider adding `.mix_tasks` to your [global .gitignore](https://help.github.com/articles/ignoring-files#global-gitignore)

## Usage

`mix`, then press tab

Currently maintained by [styx](https://github.com/styx/)
