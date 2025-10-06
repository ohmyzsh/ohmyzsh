# gpg-agent

Applies some fixes for some common issues encountered with [GPG's gpg-agent](https://www.gnupg.org/documentation/manuals/gnupg/).

More specifically, this plugin:

- Updates the `GPG_TTY` environment variable before each shell execution. 
- Updates the `SSH_AUTH_SOCK` environment variable if `enable-ssh-support` is turned on.

To use it, add `gpg-agent` to the plugins array of your zshrc file:

```zsh
plugins=(... gpg-agent)
```
