# Laravel plugin

This plugin adds aliases and autocompletion for Laravel [Artisan](https://laravel.com/docs/artisan) and [Bob](http://daylerees.github.io/laravel-bob/) command-line interfaces.

**NOTE:** completion might not work for recent Laravel versions since it hasn't been updated since 2012.
In that case, check out plugins `laravel4` and `laravel5`.

To use it, add `laravel` to the plugins array in your zshrc file:

```zsh
plugins=(... laravel)
```

## Aliases

| Alias     | Command                  | Description          |
|-----------|--------------------------|----------------------|
| artisan   | `php artisan`            | Main Artisan command |
| bob       | `php artisan bob::build` | Main Bob command     |
