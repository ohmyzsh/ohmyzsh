# Bitwarden (unofficial) CLI plugin

This plugin adds completion for [rbw](https://github.com/doy/rbw), an unofficial
CLI for [Bitwarden](https://bitwarden.com).

To use it, add `rbw` to the plugins array in your zshrc file:

```zsh
plugins=(... rbw)
```

## `rbwpw`

The `rbwpw` function is a wrapper around `rbw`. It copies the password in the
clipboard for the service you ask for and clears the clipboard 20s later.
The usage is as follows:

```zsh
rbwpw <service>
```

This plugin does not add any aliases.
