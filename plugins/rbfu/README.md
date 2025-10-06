# rbfu plugin

This plugin starts [rbfu](https://github.com/hmans/rbfu), a minimal Ruby version
manager, and adds some useful functions.

To use it, add `rbfu` to the plugins array in your zshrc file:

```zsh
plugins=(... rbfu)
```

**Note: `rbfu` is deprecated and should no longer be used.**

## Functions

- `rbfu-rubies`: lists all installed rubies available to rbfu.

- `rvm_prompt_info`: shows the Ruby version being used with rbfu.
