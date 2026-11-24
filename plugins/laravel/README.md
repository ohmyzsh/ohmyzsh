# Laravel

This plugin adds aliases and autocompletion for Laravel [Artisan](https://laravel.com/docs/artisan) and [Bob](http://daylerees.github.io/laravel-bob/) command-line interfaces.

It replaces the `laravel4` and `laravel5` plugins. Enable only `laravel` to use
the shared aliases and completion with Laravel projects of different versions.

```
plugins=(... laravel)
```

## Completion

For Laravel 4 and later, completion reads the available commands from
`artisan list --raw --no-ansi` in the current project, including custom commands.
The legacy static completion is retained for Laravel 3, which does not support
that command. No Laravel command runs when the plugin is loaded.

## Migrating from laravel4 or laravel5

Replace `laravel4` or `laravel5` in your `plugins` array with `laravel`.
The old plugin names still load `laravel`, with a deprecation notice.
Their aliases remain available, including the version-specific commands below:

| Alias | Command |
|-------|---------|
| `la4`, `la5` | `php artisan` |
| `la4dump` | `php artisan dump-autoload` |
| `la4cache`, `la5cache` | `php artisan cache:clear` |
| `la4routes` | `php artisan routes` (Laravel 4) |
| `la5routes` | `php artisan route:list` (Laravel 5 and later) |
| `la5vendor` | `php artisan vendor:publish` |

Only commands supported by your project's Laravel version can be run. The
version-specific aliases keep their original meaning; they do not translate
commands between versions.

## Settings

By default the aliases run `php artisan`. To use a different PHP command, such as
`herd php` (which runs the PHP version the [Laravel Herd](https://herd.laravel.com) site
is isolated to, instead of Herd's global version) or a specific version like `php8.4`,
set this before Oh My Zsh is sourced:

```zsh
zstyle ':omz:plugins:laravel' php 'herd php'
```

`php` in the aliases below is then replaced with that command.

For a wrapper such as `herd php`, Zsh normally attempts completion for the
wrapper after expanding the alias. To complete `artisan`, `la4`, and `la5`
directly with this plugin instead, enable Zsh's `COMPLETE_ALIASES` option:

```zsh
setopt COMPLETE_ALIASES
```

This option applies to all aliases in your shell.

## Aliases

| Alias | Description |
|:-:|:-:|
| `artisan`  | `php artisan`  |
| `pas`  | `php artisan serve` |
| `pad`  | `php artisan dev` |
| `pats`  | `php artisan test` |

## Database

| Alias | Description |
|:-:|:-:|
| `pam`  |  `php artisan migrate` |
| `pamf`  |  `php artisan migrate:fresh` |
| `pamfs`  |  `php artisan migrate:fresh --seed` |
| `pamr`  |  `php artisan migrate:rollback` |
| `pads`  |  `php artisan db:seed` |
| `padw`  |  `php artisan db:wipe` |

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
| `pamcl` | `php artisan make:class` |
| `pamen` | `php artisan make:enum` |
| `pami`  | `php artisan make:interface` |
| `pamtr` | `php artisan make:trait` |
| `pamv` | `php artisan make:view` |
| `pammig` | `php artisan make:migration` |

## Clears

| Alias | Description |
|:-:|:-:|
| `pacac`  |  `php artisan cache:clear` |
| `pacoc`  |  `php artisan config:clear` |
| `pavic`  |  `php artisan view:clear` |
| `paroc`  |  `php artisan route:clear` |
| `paopc`  |  `php artisan optimize:clear` |

## Queues

| Alias | Description |
|:-:|:-:|
| `paqf`  |  `php artisan queue:failed` |
| `paqft`  |  `php artisan queue:failed-table` |
| `paql`  |  `php artisan queue:listen` |
| `paqr`  |  `php artisan queue:retry` |
| `paqt`  |  `php artisan queue:table` |
| `paqw`  |  `php artisan queue:work` |
