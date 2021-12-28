# Ruby Version Manager plugin

This plugin adds some utility functions and completions for [Ruby Version Manager](https://rvm.io/).

To use it, add `rvm` to the plugins array in your zshrc file:

```zsh
plugins=(... rvm)
```

## Aliases

| Alias          | Command              |
|----------------|----------------------|
| `rb18`         | `rvm use ruby-1.8.7` |
| `rb19`         | `rvm use ruby-1.9.3` |
| `rb20`         | `rvm use ruby-2.0.0` |
| `rb21`         | `rvm use ruby-2.1.2` |
| `rb25`         | `rvm use ruby-2.5.9` |
| `rb26`         | `rvm use ruby-2.6.7` |
| `rb27`         | `rvm use ruby-2.7.3` |
| `rb30`         | `rvm use ruby-3.0.1` |
| `rvm-update`   | `rvm get head`       |
| `gems`         | `gem list`           |
| `rvms`         | `rvm gemset`         |
