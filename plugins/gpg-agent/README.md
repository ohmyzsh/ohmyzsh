# gpg-agent

Applies some fixes for some common issues encountered with [GPG's gpg-agent](https://www.gnupg.org/documentation/manuals/gnupg/).

More specifically, this plugin:

- Updates the `GPG_TTY` environment variable before each shell execution. 
- Updates the `SSH_AUTH_SOCK` environment variable if `gpg-agent` is your SSH
  agent. By default the plugin checks whether `enable-ssh-support` is turned
  on. The [`ssh-support` setting](#settings) lets you say so yourself.

To use it, add `gpg-agent` to the plugins array of your zshrc file:

```zsh
plugins=(... gpg-agent)
```

## Settings

Every time a shell starts, the plugin runs `gpgconf --list-options gpg-agent` to
find out whether `enable-ssh-support` is turned on. That check can be slow. If
you already know the answer, state it with the `ssh-support` style and the
plugin skips the check. Set it in your zshrc, before Oh My Zsh is sourced.

If you don't use `gpg-agent` as your SSH agent:

```zsh
zstyle ':omz:plugins:gpg-agent' ssh-support no
```

The plugin then only sets `GPG_TTY`. It leaves `SSH_AUTH_SOCK` alone, and it
doesn't update the agent's tty before each command, which only SSH support
needs.

If you do use `gpg-agent` as your SSH agent:

```zsh
zstyle ':omz:plugins:gpg-agent' ssh-support yes
```

The plugin then sets `SSH_AUTH_SOCK` without checking. `enable-ssh-support`
still has to be set in your `gpg-agent.conf` for SSH to work.

Leave the style unset to keep the automatic check.
