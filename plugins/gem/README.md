## Gem Plugin

This plugin adds completions and aliases for [Gem](https://rubygems.org/). The completions include the common `gem` subcommands as well as the installed gems in the current directory.

To use it, add `gem` to the plugins array in your zshrc file:

```zsh
plugins=(... gem)
```
## Aliases

| Alias | Command               |
|-------|-----------------------|
| gemb  | `gem build *.gemspec` |
| gemp  | `gem push *.gem`      |
| gemy  | `gem yank $1 -v $2`   |

