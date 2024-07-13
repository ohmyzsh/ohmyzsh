# ssh-agent plugin

This plugin starts automatically `ssh-agent` to set up and load whichever
credentials you want for ssh connections.

To enable it, add `ssh-agent` to your plugins:

```zsh
plugins=(... ssh-agent)
```

## Settings

**IMPORTANT: put these settings _before_ the line that sources oh-my-zsh**

### `agent-forwarding`

To enable **agent forwarding support** add the following to your zshrc file:

```zsh
zstyle :omz:plugins:ssh-agent agent-forwarding yes
```

### `helper`

To set an **external helper** to ask for the passwords and possibly store
them in the system keychain use the `helper` style. For example:

```zsh
zstyle :omz:plugins:ssh-agent helper ksshaskpass
```

### `identities`

To **load multiple identities** use the `identities` style (**this has no effect
if the `lazy` setting is enabled**). For example:

```zsh
zstyle :omz:plugins:ssh-agent identities id_rsa id_rsa2 id_github
```

**NOTE:** the identities may be an absolute path if they are somewhere other than
`~/.ssh`. For example:

```zsh
zstyle :omz:plugins:ssh-agent identities ~/.config/ssh/id_rsa ~/.config/ssh/id_rsa2 ~/.config/ssh/id_github
# which can be simplified to
zstyle :omz:plugins:ssh-agent identities ~/.config/ssh/{id_rsa,id_rsa2,id_github}
```

### `lazy`

To **NOT load any identities on start** use the `lazy` setting. This is particularly
useful when combined with the `AddKeysToAgent` setting (available since OpenSSH 7.2),
since it allows to enter the password only on first use. _NOTE: you can know your
OpenSSH version with `ssh -V`._

```zsh
zstyle :omz:plugins:ssh-agent lazy yes
```

You can enable `AddKeysToAgent` by passing `-o AddKeysToAgent=yes` to the `ssh` command,
or by adding `AddKeysToAgent yes` to your `~/.ssh/config` file [1].
See the [OpenSSH 7.2 Release Notes](http://www.openssh.com/txt/release-7.2).

### `lifetime`

To **set the maximum lifetime of the identities**, use the `lifetime` style.
The lifetime may be specified in seconds or as described in sshd_config(5)
(see _TIME FORMATS_). If left unspecified, the default lifetime is forever.

```zsh
zstyle :omz:plugins:ssh-agent lifetime 4h
```

### `quiet`

To silence the plugin, use the following setting:

```zsh
zstyle :omz:plugins:ssh-agent quiet yes
```

### `ssh-add-args`

To **pass arguments to the `ssh-add` command** that adds the identities on startup,
use the `ssh-add-args` setting. You can pass multiple arguments separated by spaces:

```zsh
zstyle :omz:plugins:ssh-agent ssh-add-args -K -c -a /run/user/1000/ssh-auth
```

These will then be passed the `ssh-add` call as if written directly. The example
above will turn into:

```zsh
ssh-add -K -c -a /run/user/1000/ssh-auth <identities>
```

For valid `ssh-add` arguments run `ssh-add --help` or `man ssh-add`.

### Powerline 10k specific settings

Powerline10k has an instant prompt setting that doesn't like when this plugin
writes to the console. Consider using the following settings if you're using
p10k (documented above):

```
zstyle :omz:plugins:ssh-agent quiet yes
zstyle :omz:plugins:ssh-agent lazy yes
```

### macOS specific settings

macOS supports using passphrases stored in the keychain when adding identities
to the ssh-agent.

```
ssh-add --apple-use-keychain ~/.ssh/id_rsa ...
```


This plugin can be configured to use the keychain when loading using the following:

```
zstyle :omz:plugins:ssh-agent ssh-add-args --apple-load-keychain
```

## Credits

Based on code from Joseph M. Reagle: https://www.cygwin.com/ml/cygwin/2001-06/msg00537.html

Agent-forwarding support based on ideas from Florent Thoumie and Jonas Pfenniger
