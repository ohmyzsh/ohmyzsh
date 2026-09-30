# Laravel Sail Oh-My-Zsh plugin

This [OMZ plugin](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins) adds aliases for typical commands with [Laravel Sail](https://laravel.com/docs/10.x/sail). It will only run within sail-driven project directories.

To use it, add `sail` to the oh-my-zsh plugins array in your `.zshrc` file:

```zsh
plugins=(... sail)
```

## Commands

| Alias      | Description     |
|:----------:|:---------------:|
| `artisan`  | `sail artisan`  |
| `composer` | `sail composer` |
| `node`     | `sail node`     |
| `npm`      | `sail npm`      |
| `npx`      | `sail npx`      |
| `php`      | `sail php`      |
| `yarn`     | `sail yarn`     |

## How it works

This plugin removes the requirement to type `sail` before a command. It utilizes the sail version of supported commands run within directories where the `sail` command is found in the `vendor/bin` directory.

## Settings

The plugin will utilize the default values. Set the variable(s) below as needed in your .zshrc file to change these default values to match your development environment:

- `SAIL_ZSH_BIN_PATH`: The plugin will check to see if this provided path exists to check for presence of Laravel Sail. By default, the path is `vendor/bin/sail` but this can be changed if needed.

## Authors

- [Marc-André Appel](https://maa.rocks)
- [https://github.com/marcandreappel/sail-zsh](https://github.com/marcandreappel/sail-zsh)

- Joshua Bedford (Author of the original Lando plugin)
- URL: [https://github.com/joshuabedford/lando-zsh](https://github.com/joshuabedford/lando-zsh)

