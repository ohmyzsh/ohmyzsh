# composer

This plugin provides completion for [composer](https://getcomposer.org/), as well as aliases
for frequent composer commands. It also adds Composer's global binaries to the PATH, using
Composer if available.

To use it add `composer` to the plugins array in your zshrc file.

```zsh
plugins=(... composer)
```

## Aliases

| Alias  | Command                                     | Description                                                                             |
| ------ | ------------------------------------------- | --------------------------------------------------------------------------------------- |
| `c`    | `composer`                                  | Starts composer                                                                         |
| `csu`  | `composer self-update`                      | Updates composer to the latest version                                                  |
| `cu`   | `composer update`                           | Updates composer dependencies and `composer.lock` file                                  |
| `cr`   | `composer require`                          | Adds new packages to `composer.json`                                                    |
| `crm`  | `composer remove`                           | Removes packages from `composer.json`                                                   |
| `ci`   | `composer install`                          | Resolves and installs dependencies from `composer.json`                                 |
| `ccp`  | `composer create-project`                   | Create new project from an existing package                                             |
| `cdu`  | `composer dump-autoload`                    | Updates the autoloader                                                                  |
| `cdo`  | `composer dump-autoload -o`                 | Converts PSR-0/4 autoloading to classmap for a faster autoloader (good for production)  |
| `cgu`  | `composer global update`                    | Allows update command to run on COMPOSER_HOME directory                                 |
| `cgr`  | `composer global require`                   | Allows require command to run on COMPOSER_HOME directory                                |
| `cgrm` | `composer global remove`                    | Allows remove command to run on COMPOSER_HOME directory                                 |
| `cget` | `curl -s https://getcomposer.org/installer` | Installs composer in the current directory                                              |
| `co`   | `composer outdated`                         | Shows a list of installed packages with available updates                               |
| `cod`  | `composer outdated --direct`                | Shows a list of installed packages with available updates which are direct dependencies |
