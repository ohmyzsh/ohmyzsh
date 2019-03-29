# keychain plugin

This plugin starts automatically [`keychain`](https://www.funtoo.org/Keychain)
to set up and load whichever credentials you want for both gpg and ssh
connections.

To enable it, add `keychain` to your plugins:

```zsh
plugins=(... keychain)
```

**NOTE**: It is HIGHLY recommended to also enable the `gpg-agent` plugin.

## Instructions

**IMPORTANT: put these settings _before_ the line that sources oh-my-zsh**

**To adjust the agents** that keychain manages, use the `agents` style as
shown below. By default, only the `gpg` agent is managed.

```zsh
zstyle :omz:plugins:keychain agents gpg,ssh
```

To **load multiple identities** use the `identities` style, For example:

```zsh
zstyle :omz:plugins:keychain identities id_ed25519 id_github 2C5879C2
```

**To pass additional options** to the `keychain` program, use the
`options` style; for example:

```zsh
zstyle :omz:plugins:keychain options --quiet
```

## Credits

Based on code from the `ssh-agent` plugin.

## References

- [Keychain](https://www.funtoo.org/Keychain)
