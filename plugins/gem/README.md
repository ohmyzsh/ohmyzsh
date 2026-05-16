# Gem plugin

This plugin adds completions and aliases for [Gem](https://rubygems.org/). The completions include the common `gem` subcommands as well as the installed gems in the current directory.

To use it, add `gem` to the plugins array in your zshrc file:

```zsh
plugins=(... gem)
```

## Aliases

| Alias                | Command                       | Description                                |
|----------------------|-------------------------------|--------------------------------------------|
| gemb                 | `gem build *.gemspec`         | Build a gem from a gemspec                 |
| gemp                 | `gem push *.gem`              | Push a gem up to the gem server            |
| gemy [gem] [version] | `gem yank [gem] -v [version]` | Remove a pushed gem version from the index |
