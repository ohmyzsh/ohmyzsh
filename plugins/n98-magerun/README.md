# n98-magerun plugin

The n98-magerun plugin provides convenient aliases and tab completion support for the [n98-magerun](https://github.com/netz98/n98-magerun) CLI tools — powerful command-line utilities designed for Magento 1 and Magento 2. These tools are essential for Magento developers, system administrators, and DevOps engineers, offering a wide variety of well-tested commands that streamline development and management tasks.

This plugin is intended to improve your development workflow by offering:
 - Handy aliases for quickly running Magento CLI tools
 - Auto-completion for available n98-magerun commands
 - Easy installation shortcuts for downloading the latest `.phar` binaries

## Enabling the Plugin

To enable the plugin, add `n98-magerun` to the list of plugins in your `.zshrc` configuration file:

```zsh
plugins=(... n98-magerun)
```

## Command Autocompletion

Once enabled, this plugin provides tab completion for available `n98-magerun` and `n98-magerun2` commands. The plugin dynamically fetches the list of available commands by parsing the output of the `--no-ansi` help command, which ensures you always get up-to-date completions for:

 - `n98-magerun`
 - `n98-magerun2`
 - Any aliased variants like `n98`, `mage`, `magerun`, etc.

This is particularly useful working with Magento environments where command memorization can become overwhelming. Tab completion allows you to quickly explore available options.

## Aliases

The plugin defines a set of meaningful aliases to simplify command usage:

| Alias      | Command             | Description                                         |
| ---------- | ------------------- | --------------------------------------------------- |
| `n98`      | `n98-magerun.phar`  | Executes the N98-Magerun tool for Magento 1         |
| `mage`     | `n98-magerun.phar`  | Same as `n98` - alternative alias for Magento 1     |
| `magerun`  | `n98-magerun.phar`  | Another alias for running the Magento 1 CLI tool    |
| `n98-2`    | `n98-magerun2.phar` | Executes the N98-Magerun2 tool for Magento 2        |
| `mage2`    | `n98-magerun2.phar` | Alias for `n98-2` - intended for use with Magento 2 |
| `magerun2` | `n98-magerun2.phar` | Another shorthand alias for the Magento 2 CLI tool  |

These aliases reduce the need to type long commands and help you quickly switch between Magento 1 and Magento 2 tools, depending on your project context.

## Quick Installation Shortcuts

Downloading the latest `.phar` files for Magento CLI tools is made simpler with these aliases:

| Alias       | Command                                             | Description                                                                            |
| ----------- | --------------------------------------------------- | -------------------------------------------------------------------------------------- |
| `mage-get`  | `wget https://files.magerun.net/n98-magerun.phar`   | Downloads the latest stable release of n98-magerun for Magento 1 from the file server  |
| `mage2-get` | `	wget https://files.magerun.net/n98-magerun2.phar` | Downloads the latest stable release of n98-magerun2 for Magento 2 from the file server |

These shortcuts help you bootstrap your Magento CLI tools without needing to remember URLs or version numbers.

## Compatibility

This plugin supports both Magento 1 and Magento 2 via:
 - `n98-magerun.phar` for Magento 1
 - `n98-magerun2.phar` for Magento 2
You may keep both tools in the same environment and switch between them using the provided aliases.
