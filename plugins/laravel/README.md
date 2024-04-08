# Laravel

This plugin adds aliases and autocompletion for Laravel [Artisan](https://laravel.com/docs/artisan) and [Bob](http://daylerees.github.io/laravel-bob/) command-line interfaces.

```
plugins=(... laravel)
```

| Alias | Description |
|:-:|:-:|
| `artisan`  | `php artisan`  |
| `pas`  | `php artisan serve` |
| `pats`  | `php artisan test` |

## Database

| Alias | Description |
|:-:|:-:|
| `pam`  |  `php artisan migrate` |
| `pamf`  |  `php artisan migrate:fresh` |
| `pamfs`  |  `php artisan migrate:fresh --seed` |
| `pamr`  |  `php artisan migrate:rollback` |
| `pads`  |  `php artisan db:seed` |

## Makers

| Alias | Description |
|:-:|:-:|
| `pamm`  |  `php artisan make:model` |
| `pamc`  |  `php artisan make:controller` |
| `pams`  |  `php artisan make:seeder` |
| `pamt`  |  `php artisan make:test` |
| `pamfa`  |  `php artisan make:factory` |
| `pamp`  |  `php artisan make:policy` |
| `pame`  |  `php artisan make:event` |
| `pamj`  |  `php artisan make:job` |
| `paml`  |  `php artisan make:listener` |
| `pamn`  |  `php artisan make:notification` |

## Clears

| Alias | Description |
|:-:|:-:|
| `pacac`  |  `php artisan cache:clear` |
| `pacoc`  |  `php artisan config:clear` |
| `pavic`  |  `php artisan view:clear` |
| `paroc`  |  `php artisan route:clear` |

## Queues

| Alias | Description |
|:-:|:-:|
| `paqf`  |  `php artisan queue:failed` |
| `paqft`  |  `php artisan queue:failed-table` |
| `paql`  |  `php artisan queue:listen` |
| `paqr`  |  `php artisan queue:retry` |
| `paqt`  |  `php artisan queue:table` |
| `paqw`  |  `php artisan queue:work` |
