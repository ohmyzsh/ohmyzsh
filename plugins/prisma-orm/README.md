## Prisma ORM ZSH Plugin
#### Overview
This Prisma plugin for ZSH enhances your command line experience by providing handy autocompletion, shortcuts, and environment-aware functionality for working with Prisma ORM. It's designed to streamline your workflow and make interacting with Prisma a breeze (or at least less of a headache).

#### Features
* Autocompletion: Get suggestions for Prisma commands, subcommands, and options.
* Dynamic Schema Loading: Automatically loads Prisma schema based on your environment settings.
* Verbose Output Toggle: Easily switch between verbose and regular output for Prisma commands.
* Model-Specific Aliases: Quickly interact with specific models in your Prisma schema.

#### Installation
1. Clone this repository or download the files.
2. Place the `prisma-orm.plugin.zsh` file into your custom plugins directory, usually `~/.oh-my-zsh/custom/plugins/`.
3. Add prisma to the plugins array in your `.zshrc` file.
4. Reload your terminal or run `source ~/.zshrc`.

#### Usage
After installation, you'll have access to the following functionalities:
* Autocomplete Prisma Commands:
Type `prisma` and press `Tab` to see available commands and options.
* Dynamic Schema Loading:
The plugin checks for a `.env` file in your project directory and loads the schema file specified there.
* Toggle Verbose Output:
    * `prisma_verbose`: Enable verbose output.
    * `prisma_quiet`: Disable verbose output.
* Model-Specific Aliases:
    * Replace 'User' in the aliases with your actual model names.
    * Example aliases:
        * `prisma_user_create`: Shortcut to create a new User record.
        * `prisma_user_delete`: Shortcut to delete a User record.

#### Customization
* To customize the schema file location, modify the     `_prisma_set_schema` function in `prisma-orm.plugin.zsh` file.
* Add or modify aliases in `prisma-orm.plugin.zsh` file as per your project needs.
