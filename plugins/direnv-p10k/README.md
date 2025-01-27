# direnv plugin

This plugin creates the [Direnv](https://direnv.net/) hook.

This hook is tweaked to prevent issues with the powerlevel10k theme's instant prompt feature by not adding the direnv hook to precmd_functions

To use it, add `direnv-p10k` to the plugins array in your zshrc file:

```zsh
plugins=(... direnv-p10k)
```

## Requirements

In order to make this work, you will need to have direnv installed.

More info on the usage and install: https://github.com/direnv/direnv
