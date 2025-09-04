# gpg-agent

Enables [GPG's gpg-agent](https://www.gnupg.org/documentation/manuals/gnupg/) if it is not running and fixes some common issues.

Issues fixed are:

* The `GPG_TTY` environment variable being set incorrectly or not set at all.
* SSH agent support being broken when `enable-ssh-support` is enabled.

To use it, add `gpg-agent` to the plugins array of your zshrc file:

```zsh
plugins=(... gpg-agent)
```
