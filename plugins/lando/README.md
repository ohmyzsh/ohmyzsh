
# Lando ZSH (lando-zsh)
*A simple collection of alias functions to enable the use of the CLIs within Lando without having to type `lando` to access them.*

#### PURPOSE:
To enable the use of common commands in web development without having to prepend `lando` to them. E.G. `lando composer` becomes simply `composer` and `lando npm` becomes `npm`.

The functions *should* enable the ability to not have to type `lando` before a command by prepending 'lando' for all commands executed in the same directory as a .lando.yml config file, but preserve the use of non-lando commands with the same name.

#### WARNING:
- **Note:** This assumes your lando projects are located at `$HOME/Sites` (E.G. /Users/username/Sites).
- This could conflict with any aliases previously installed. If you have any of the CLIs installed globally (outside of Lando). 
- The `if` statements *should* account for this by calling the non-lando command for you, but not all have been tested fully.

## USE
- Clone this project into your `custom/plugins` folder:
	- `cd ~/.oh-my-zsh/custom/plugins`
	- via SSH: 		`git clone git@github.com:JoshuaBedford/lando-zsh.git lando`
	- via HTTPS: 	`git clone https://github.com/JoshuaBedford/lando-zsh.git lando`
- Update the `CONFIG_FILE` variable if your config file is a different name.