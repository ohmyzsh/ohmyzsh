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

## Nwidart Modules

| Alias | Description |
|:-:|:-:|
| `pmmake`  |  `php artisan module:make` |
| `pmlist`  |  `php artisan module:list` |
| `pmmigrate`  |  `php artisan module:migrate` |
| `pmrollback`  |  `php artisan module:migrate-rollback` |
| `pmrefresh`  |  `php artisan module:migrate-refresh` |
| `pmreset`  |  `php artisan module:migrate-reset` |
| `pmseed`  |  `php artisan module:seed` |
| `pmenable`  |  `php artisan module:enable` |
| `pmdisable`  |  `php artisan module:disable` |

## Nwidart Module Generator Commands

| Alias | Description |
|:-:|:-:|
| `pmcommand`  |  `php artisan module:make-command` |
| `pmmigration`  |  `php artisan module:make-migration` |
| `pmseed`  |  `php artisan module:make-seed` |
| `pmcontroller`  |  `php artisan module:make-controller` |
| `pmmodel`  |  `php artisan module:make-model` |
| `pmprovider`  |  `php artisan module:make-provider` |
| `pmmiddleware`  |  `php artisan module:make-middleware` |
| `pmmail`  |  `php artisan module:make-mail` |
| `pmnotification`  |  `php artisan module:make-notification` |
| `pmlistener`  |  `php artisan module:make-listener` |
| `pmrequest`  |  `php artisan module:make-request` |
| `pmevent`  |  `php artisan module:make-event` |
| `pmjob`  |  `php artisan module:make-job` |
| `pmrprovider`  |  `php artisan module:route-provider` |
| `pmfactory`  |  `php artisan module:make-factory` |
| `pmpolicy`  |  `php artisan module:make-policy` |
| `pmrule`  |  `php artisan module:make-rule` |
| `pmresource`  |  `php artisan module:make-resource` |
| `pmtest`  |  `php artisan module:make-test` |

