# Laravel Art plugin

This plugin adds some aliases for common [Laravel](https://laravel.com/docs/) commands.

To use it, add `laravel-art` to the plugins array in your zshrc file:

```zsh
plugins=(... laravel-art)
```

## Aliases

| Alias     | Command                              | Description                         |
|-----------|--------------------------------------|-------------------------------------|
| art       | `php artisan`                        | Main Artisan command                |
| arts      | `php artisan serve`                  | Serve the application               |
| arto      | `php artisan optimize`               | Cache the framework bootstrap files  |
| artr      | `php artisan route:list`             | List all registered routes          |
| artm      | `php artisan migrate`                | Run the database migrations         |
| artmf     | `php artisan migrate:fresh`          | Drop all tables and re-run all migrations  |
| artmfseed | `php artisan migrate:fresh --seed`   | Drop tables and re-run migrations then seed|
| artdbseed | `php artisan db:seed`                | Seed the database with records      |
| artmodseed| `php artisan module:seed`            | Seed the database from module package|
| artcache  | `php artisan cache:clear`            | Flush the application cache         |


## And Many Other Aliases
