# addomzuser

This plugin adds support for installing "Oh My ZSH" when adding new users.

To use it, add `addomzuser` to the plugins array of your `~/.zshrc` file:

```zsh
plugins=(... addomzuser)
```

## Usage

Just run `addomzuser` as you normally would run `adduser` and now:

1. The regular `adduser` command will run.
2. The shell of the new user will switch to zsh
3. "Oh My zsh will be installed (as if he would have ran `install.sh` himself).

## NOTES

- It is assumed that the last argument will be the username.<br>*(In rare cases people provide the group as last argument)*
- The regular `adduser` and `useradd` commands will continue to behave as normal.

## Author

[Nikolas Garofil](https://github.com/ngaro)
