# composer

This plugin provides completion for [composer](https://getcomposer.org/),
as well as aliases for frequent composer commands.

To use it add `composer` to the plugins array in your zshrc file.

```zsh
plugins=(... composer)
```

## Aliases

| Alias  | Command                                       | Description                                                                                                                     |
| ------ | --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `c`    | composer                                      | Start composer, get help with composer commands                                                                                 |
| `csu`  | composer self-update                          | Update composer to the latest version                                                                                           |
| `cu`   | composer update                               | Update composer dependencies and `composer.lock` file                                                                           |
| `cr`   | composer require                              | Adds new packages to the  `composer.json` file from current directory                                                           |
| `crm`  | composer remove                               | Removes packages from the `composer.json` file from the current directory                                                       |
| `ci`   | composer install                              | Reads the `composer.json` file from the current directory, resolves the dependencies, and installs them into `vendor`           |
| `ccp`  | composer create-project                       | Create new project from an existing package                                                                                     |
| `cdu`  | composer dump-autoload                        | Update the autoloader due to new classes in a classmap package without having to go through an install or update                |
| `cdo`  | composer dump-autoload --optimize-autoloader  | Convert PSR-0/4 autoloading to classmap to get a faster autoloader. Recommended especially for production, set `no` by default  |
| `cgu`  | composer global update                        | Allows update command to run on COMPOSER_HOME directory                                                                         |                                 
| `cgr`  | composer global require                       | Allows require command to run on COMPOSER_HOME directory                                                                        |
| `cgrm` | composer global remove                        | Allows remove command to run on COMPOSER_HOME directory                                                                         |
| `cget` | `curl -s https://getcomposer.org/installer`   | Installs composer in the current directory                                                                                      |


The plugin adds Composer's global binaries to PATH, using Composer if available.
