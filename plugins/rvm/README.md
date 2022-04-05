# Ruby Version Manager plugin

This plugin adds some utility functions and completions for [Ruby Version Manager](https://rvm.io/).

To use it, add `rvm` to the plugins array in your zshrc file:

```zsh
plugins=(... rvm)
```

## Aliases

| Alias        | Command              |
| ------------ | -------------------- |
| `rb18`       | `rvm use ruby-1.8.7` |
| `rb19`       | `rvm use ruby-1.9.3` |
| `rb20`       | `rvm use ruby-2.0.0` |
| `rb21`       | `rvm use ruby-2.1`   |
| `rb22`       | `rvm use ruby-2.2`   |
| `rb23`       | `rvm use ruby-2.3`   |
| `rb24`       | `rvm use ruby-2.4`   |
| `rb25`       | `rvm use ruby-2.5`   |
| `rb26`       | `rvm use ruby-2.6`   |
| `rb27`       | `rvm use ruby-2.7`   |
| `rb30`       | `rvm use ruby-3.0`   |
| `rb31`       | `rvm use ruby-3.1`   |
| `rvm-update` | `rvm get head`       |
| `gems`       | `gem list`           |
| `rvms`       | `rvm gemset`         |

## Deprecated versions

At the time of writing this (2021-12-28), Ruby versions until 2.5 are [EOL][1],
and will be removed in the future.

[1]: https://endoflife.date/ruby
