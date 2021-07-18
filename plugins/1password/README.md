# 1Password

This plugin adds 1Password functionality to oh-my-zsh.

To use, add `1password` to the list of plugins in your `.zshrc` file:

```zsh
plugins=(... 1password)
```

Then, you can use the command `opswd` to copy passwords for services into your
clipboard.

For example, `opswd GitHub` will put your GitHub password into your clipboard - if a
onetime password exists for the service, your clipboard will contain it after a
brief pause. Everything is cleared after few seconds.

NOTE: you need to be logged in for `opswd` to work. See:

- [Sign in or out](https://support.1password.com/command-line/#sign-in-or-out)
- [Session management](https://support.1password.com/command-line/#appendix-session-management)

## Requirements

- [1Password's command line utility](https://1password.com/downloads/command-line/).
- [`jq`](https://stedolan.github.io/jq/).
