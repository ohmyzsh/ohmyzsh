# Autoenv plugin

This plugin loads the [Autoenv](https://github.com/inishchith/autoenv).

To use it, add `autoenv` to the plugins array in your zshrc file:

```zsh
plugins=(... autoenv)
```

## Functions

* `use_env()`: creates and/or activates a virtualenv. For use in `.env` files.
  See the source code for details.

## Requirements

In order to make this work, you will need to have the autoenv installed.

More info on the usage and install at [the project's homepage](https://github.com/inishchith/autoenv).
