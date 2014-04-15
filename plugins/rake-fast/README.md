# rake-fast

Fast rake autocompletion plugin.

This script caches the output for later usage and significantly speeds it up. It generates a .rake_tasks cache file in parallel to the Rakefile. It also checks the file modification dates to see if it needs to regenerate the cache file.

This is entirely based on [this pull request by Ullrich Schäfer](https://github.com/robb/.dotfiles/pull/10/), which is inspired by [this Ruby on Rails trick from 2006](http://weblog.rubyonrails.org/2006/3/9/fast-rake-task-completion-for-zsh/).

Think about that. 2006.

## Installation

Just add the plugin to your `.zshrc`:

```bash
plugins=(foo bar rake-fast)
```

You might consider adding `.rake_tasks` to your [global .gitignore](https://help.github.com/articles/ignoring-files#global-gitignore)

## Usage

`rake`, then press tab
