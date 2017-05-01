# ssh-agent plugin

This plugin starts automatically `ssh-agent` to set up and load whichever
credentials you want for ssh connections.

To enable it, add `ssh-agent` to your plugins:

```zsh
plugins=(... ssh-agent)
```

## Instructions

To enable **agent forwarding support** add the following to your zshrc file:

```zsh
zstyle :omz:plugins:ssh-agent agent-forwarding on
```

To **load multiple identities** use the `identities` style, For example:

```zsh
zstyle :omz:plugins:ssh-agent identities id_rsa id_rsa2 id_github
```

To **set the maximum lifetime of the identities**, use the `lifetime` style.
The lifetime may be specified in seconds or as described in sshd_config(5)
(see _TIME FORMATS_). If left unspecified, the default lifetime is forever.

```zsh
zstyle :omz:plugins:ssh-agent lifetime 4h
```

## Credits

Based on code from Joseph M. Reagle: http://www.cygwin.com/ml/cygwin/2001-06/msg00537.html

Agent-forwarding support based on ideas from Florent Thoumie and Jonas Pfenniger
