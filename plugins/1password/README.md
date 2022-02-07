# 1Password

This plugin adds 1Password functionality to oh-my-zsh.

To use, add `1password` to the list of plugins in your `.zshrc` file:

```zsh
plugins=(... 1password)
```

Then, you can use the command `opswd` to copy passwords for services into your
clipboard.

## `opswd`

The `opswd` command is a wrapper around the `op` command. It takes a service
name as an argument and copies the password for that service to the clipboard.

If the service also contains a TOTP, it is copied to the clipboard after 10 seconds.
Finally, after 20 seconds, the clipboard is cleared.

The function has completion support, so you can use tab completion to select
which service you want to get.

For example, `opswd github.com` will put your GitHub password into your clipboard, and if
a TOTP is available, it will be copied to the clipboard after 10 seconds.

> NOTE: you need to be logged in for `opswd` to work. See:
>
> - [Sign in or out](https://support.1password.com/command-line/#sign-in-or-out)
> - [Session management](https://support.1password.com/command-line/#appendix-session-management)

## Requirements

- [1Password's command line utility](https://1password.com/downloads/command-line/).
