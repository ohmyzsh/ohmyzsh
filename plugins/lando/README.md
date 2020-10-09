
# Lando ZSH (lando-zsh)
This plugin adds aliases for using various languages and frameworks with [Lando](https://docs.lando.dev/basics/) for Docker. It will only run within lando-driven project directories.

#### USAGE:
```
plugins=(... lando)
```

#### ALIASES:
| Alias | Description |
|:-:|:-:|
| `artisan`  | `lando artisan`  |
| `composer`  | `lando composer`  |
| `drush`  | `lando drush`  |
| `gulp`  | `lando gulp`  |
| `npm`  | `lando npm`  |
| `wp`  | `lando wp`  |
| `yarn`  | `lando yarn`  |

#### How It Works:
This plugin removes the requirement to type `lando` before a command. It prepends 'lando' for commands executed in the same directory as a .lando.yml config file, but preserves the use of non-lando commands with the same name.

#### Settings: 
- `LANDO_ZSH_SITES_DIREECTORY`: The plugin will stop searching through parents for `CONFIG_FILE` once it hits this directory.
- `LANDO_ZSH_CONFIG_FILE`: The plugin will check to see if this provided file exists to check for presence of Lando.

##### Author:
- Author: Joshua Bedford
- URL: github.com/joshuabedford/lando-zsh
