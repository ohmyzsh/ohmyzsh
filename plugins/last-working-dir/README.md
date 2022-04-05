# last-working-dir plugin

Keeps track of the last used working directory and automatically jumps into it
for new shells, unless the starting directory is not `$HOME`.

Also adds a `lwd` function to jump to the last working directory.

To use it, add `last-working-dir` to the plugins array in your zshrc file:

```zsh
plugins=(... last-working-dir)
```

## Features

### Use separate last-working-dir files with different SSH keys

If the same user account is used by multiple users connecting via different SSH keys, you can
configure SSH to map them to different `SSH_USER`s and the plugin will use separate lwd files
for each one.

Make sure that your SSH server allows environment variables. You can enable this feature
within the `/etc/sshd/sshd_config` file:

```
PermitUserEnvironment yes
```

Then, add `environment="SSH_USER=<SSH_USERNAME>"` before the SSH keys in your `authorized_keys` file:

```
environment="SSH_USER=a.test@example.com" ssh-ed25519 AAAAC3Nz...
```
