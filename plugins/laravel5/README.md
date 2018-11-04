# Laravel 5 plugin

This plugin adds some aliases for common [Laravel 5](https://laravel.com/docs) commands.

To use it, add `laravel5` to the plugins array in your zshrc file:

```zsh
plugins=(... laravel5)
```

## Aliases

| Alias     | Command                      | Description                                        |
|-----------|------------------------------|----------------------------------------------------|
| la5       | `php artisan`                | Main Artisan command                               |
| la5cache  | `php artisan cache:clear`    | Flush the application cache                        |
| la5routes | `php artisan route:list`     | List all registered routes                         |
| la5vendor | `php artisan vendor:publish` | Publish any publishable assets from vendor package |
