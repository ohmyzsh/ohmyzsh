# composer

This plugin provides completion for [composer](https://getcomposer.org/), as well as aliases
for frequent composer commands. It also adds Composer's global binaries to the PATH, using
Composer if available.

To use it add `composer` to the plugins array in your zshrc file.

```zsh
plugins=(... composer)
```

Original author: Daniel Gomes <me@danielcsgomes.com>

## Aliases

| Alias  | Command                            | Description                                                                             |
| ------ | ---------------------------------- | --------------------------------------------------------------------------------------- |
| `c`    | `composer`                         | Starts composer                                                                         |
| `ccp`  | `composer create-project`          | Create new project from an existing package                                             |
| `cdo`  | `composer dump-autoload -o`        | Converts PSR-0/4 autoloading to classmap for a faster autoloader (good for production)  |
| `cdu`  | `composer dump-autoload`           | Updates the autoloader                                                                  |
| `cget` | `curl -s <installer> \| php`       | Installs composer in the current directory                                              |
| `cgr`  | `composer global require`          | Allows require command to run on COMPOSER_HOME directory                                |
| `cgrm` | `composer global remove`           | Allows remove command to run on COMPOSER_HOME directory                                 |
| `cgu`  | `composer global update`           | Allows update command to run on COMPOSER_HOME directory                                 |
| `ci`   | `composer install`                 | Resolves and installs dependencies from `composer.json`                                 |
| `co`   | `composer outdated`                | Shows a list of installed packages with available updates                               |
| `cod`  | `composer outdated --direct`       | Shows a list of installed packages with available updates which are direct dependencies |
| `cr`   | `composer require`                 | Adds new packages to `composer.json`                                                    |
| `crm`  | `composer remove`                  | Removes packages from `composer.json`                                                   |
| `cs`   | `composer show`                    | Lists available packages, with optional filtering                                       |
| `csu`  | `composer self-update`             | Updates composer to the latest version                                                  |
| `cu`   | `composer update`                  | Updates composer dependencies and `composer.lock` file                                  |
| `cuh`  | `composer update -d <config-home>` | Updates globally installed packages                                                     |
