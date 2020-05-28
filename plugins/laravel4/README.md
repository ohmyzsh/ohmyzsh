# Laravel 4 plugin

This plugin adds some aliases for common [Laravel 4](https://laravel.com/docs/4.2) commands.

To use it, add `laravel4` to the plugins array in your zshrc file:

```zsh
plugins=(... laravel4)
```

## Aliases

| Alias     | Command                     | Description                         |
|-----------|-----------------------------|-------------------------------------|
| la4       | `php artisan`               | Main Artisan command                |
| la4dump   | `php artisan dump-autoload` | Regenerate framework autoload files |
| la4cache  | `php artisan cache:clear`   | Flush the application cache         |
| la4routes | `php artisan routes`        | List all registered routes          |
