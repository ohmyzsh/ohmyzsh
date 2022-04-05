# Drush

This plugin adds aliases and functions for [Drush](https://www.drush.org), a command-line shell
and Unix scripting interface for Drupal. It also adds completion for the `drush` command.

To enable it, add `drush` to the plugins array in zshrc file:

```zsh
plugins=(... drush)
```

## Aliases

| Alias   | Command                                                     | Description                                                          |
| ------- | ----------------------------------------------------------- | -------------------------------------------------------------------- |
| `dr`    | `drush`                                                     | Display drush help                                                   |
| `drca`  | `drush cc all`                                              | _(Deprecated in Drush 8)_ Clear all drupal caches                    |
| `drcb`  | `drush cc block`                                            | _(Deprecated in Drush 8)_ Clear block cache                          |
| `drcex` | `drush config:export -y`                                    | Export Drupal configuration to a directory                           |
| `drcg`  | `drush cc registry`                                         | _(Deprecated in Drush 8)_ Clear registry cache                       |
| `drcim` | `drush config:import -y`                                    | Import config from a config directory                                |
| `drcj`  | `drush cc css-js`                                           | Clear css-js cache                                                   |
| `drcm`  | `drush cc menu`                                             | Clear menu cache                                                     |
| `drcml` | `drush cc module-list`                                      | Clear module-list cache                                              |
| `drcr`  | `drush core-cron`                                           | Run all cron hooks in all active modules for specified site          |
| `drct`  | `drush cc theme-registry`                                   | Clear theme-registry cache                                           |
| `drcv`  | `drush cc views`                                            | Clear views cache _(make sure that the views module is enabled)_     |
| `drdmp` | `drush drush sql-dump --ordered-dump --result-file=dumpsql` | Backup database in a new dump.sql file                               |
| `drf`   | `drush features`                                            | Display features status                                              |
| `drfr`  | `drush features-revert -y`                                  | Revert a feature module on your site                                 |
| `drfra` | `drush features-revert-all`                                 | Revert all enabled feature module on your site                       |
| `drfu`  | `drush features-update -y`                                  | Update a feature module on your site                                 |
| `drif`  | `drush image-flush --all`                                   | Flush all derived images                                             |
| `drpm`  | `drush pm-list --type=module`                               | Show a list of available modules                                     |
| `drst`  | `drush core-status`                                         | Provides a birds-eye view of the current Drupal installation, if any |
| `druli` | `drush user:login`                                          | Display a one time login link for user ID 1, or another user         |
| `drup`  | `drush updatedb`                                            | Apply any database updates required (as with running update.php)     |
| `drups` | `drush updatedb-status`                                     | List any pending database updates                                    |
| `drv`   | `drush version`                                             | Show drush version                                                   |
| `drvd`  | `drush variable-del`                                        | Delete a variable                                                    |
| `drvg`  | `drush variable-get`                                        | Get a list of some or all site variables and values                  |
| `drvs`  | `drush variable-set`                                        | Set a variable                                                       |
| `drws`  | `drush watchdog:show`                                       | Show watchdog messages                                               |
| `drwse` | `drush watchdog:show --extended`                            | Show watchdog messages with extended information                     |
| `drwst` | `drush watchdog:tail`                                       | Tail watchdog messages                                              |

## Functions

- `dren`: download and enable one or more extensions (modules or themes). Must be
  invoked with one or more parameters, e.g.: `dren devel` or `dren devel module_filter views`.

- `drf`: edit drushrc, site alias, and Drupal settings.php files.
  Can be invoked with one or without parameters, e.g.: `drf 1`.

- `dris`: disable one or more extensions (modules or themes). Must be invoked with
  one or more parameters, e.g.: `dris devel` or `dris devel module_filter views`.

- `drpu`: uninstall one or more modules. Must be invoked with one or more
  parameters, e.g.: `drpu devel` or `drpu devel module_filter views`.

- `drnew`: creates a brand new drupal website. Note: as soon as the installation
  is complete, `drush` will print a username and a random password into the terminal:

  ```text
  Installation complete.  User name: admin  User password: cf7t8yqNEm
  ```
