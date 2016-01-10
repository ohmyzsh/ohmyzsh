# Drush

## Description
This plugin offers aliases and functions to make the work with drush easier and more productive.

To enable it, add the `drush` to your `plugins` array in `~/.zshrc`:

```
plugins=(... drush)
```

## Aliases
| Alias | Description                                                           | Command                     |
|-------|-----------------------------------------------------------------------|-----------------------------|
| drca  | Clear all drupal caches.                                              | drush cc all                |
| drcb  | Clear block cache.                                                    | drush cc block              |
| drcg  | Clear registry cache.                                                 | drush cc registry           |
| drcj  | Clear css-js cache.                                                   | drush cc css-js             |
| drcm  | Clear menu cache.                                                     | drush cc menu               |
| drcml | Clear module-list cache.                                              | drush cc module-list        |
| drcr  | Run all cron hooks in all active modules for specified site.          | drush core-cron             |
| drct  | Clear theme-registry cache.                                           | drush cc theme-registry     |
| drcv  | Clear views cache. (Make sure that the views module is enabled)       | drush cc views              |
| drif  | Flush all derived images.                                             | drush image-flush --all     |
| drpm  | Show a list of available modules.                                     | drush pm-list --type=module |
| drst  | Provides a birds-eye view of the current Drupal installation, if any. | drush core-status           |
| drup  | Apply any database updates required (as with running update.php).     | drush updatedb              |
| drups | List any pending database updates.                                    | drush updatedb-status       |
| drv   | Show drush version.                                                   | drush version               |


## Functions

### dren
Download and enable one or more extensions (modules or themes).
Must be invoked with one or more parameters. e.g.:
`dren devel` or `dren devel module_filter views`

### drf
Edit drushrc, site alias, and Drupal settings.php files.
Can be invoked with one or without parameters. e.g.:
`drf 1`

### dris
Disable one or more extensions (modules or themes)
Must be invoked with one or more parameters. e.g.:
`dris devel` or `dris devel module_filter views`

### drpu
Uninstall one or more modules.
Must be invoked with one or more parameters. e.g.:
`drpu devel` or `drpu devel module_filter views`

### drnew
Creates a brand new drupal website.
Note: As soon as the installation is complete, drush will print a username and a random password into the terminal:
```
Installation complete.  User name: admin  User password: cf7t8yqNEm
```

## Additional features

### Autocomplete
The [completion script for drush](https://github.com/drush-ops/drush/blob/8.0.1/drush.complete.sh) comes enabled with this plugin.
So, it is possible to type a command:
```
drush sql
```

And as soon as the tab key is pressed, the script will display the available commands:
```
drush sql
sqlc           sql-conf       sql-create     sql-dump       sql-query      sql-sanitize                
sql-cli        sql-connect    sql-drop       sqlq           sqlsan         sql-sync
```
