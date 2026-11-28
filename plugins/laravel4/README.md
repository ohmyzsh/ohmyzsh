# Laravel 4 plugin

This plugin is deprecated. Use the [laravel plugin](../laravel) instead:

```zsh
plugins=(... laravel)
```

This compatibility loader sources `laravel` for shared aliases and completion,
then adds the original `la4`, `la4dump`, `la4cache`, and `la4routes` aliases.
These version-specific aliases are only available while `laravel4` is enabled.
When switching to `laravel` alone, use `artisan` or the shared aliases, or define
any shortcuts you still need in your own configuration.
