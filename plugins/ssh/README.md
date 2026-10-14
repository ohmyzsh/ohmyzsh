# ssh plugin

This plugin provides host completion based off of your `~/.ssh/config` file, and adds
some utility functions to work with SSH keys.

To use it, add `ssh` to the plugins array in your zshrc file:

```zsh
plugins=(... ssh)
```

## Functions

- `ssh_rmhkey`: remove host key from known hosts based on a host section name from `.ssh/config`.
- `ssh_load_key`: load SSH key into agent.
- `ssh_unload_key`: remove SSH key from agent.
- `ssh_fingerprint` : calculate fingerprint of specifed key files. It has some options:
  - `-md5` : Use MD5 fingerprint instead of SHA256
  - `-n` : Don't colorize using ANSI
  - `-q` : Don't print filename(s)
  - If key files are not specified, defaults to `~/.ssh/authorized_keys`
  - `ssh_fp` is an alias to this function

