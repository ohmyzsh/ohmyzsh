# last-working-dir plugin

## Introduction

Keeps track of the last used working directory and automatically jumps into it
for new shells, unless:

- The plugin is already loaded.
- The current `$PWD` is not `$HOME`.

Also adds `lwd` function to jump to the last working directory.

To use it, add `last-working-dir` to the plugins array in your zshrc file:

```zsh
plugins=(... last-working-dir)
```

## Features

### Separate lwd with different SSH keys

Seperate working directories on a user account with different SSH keys.

Be sure that your SSH server allow environment variables. You can enable this feature within the `/etc/sshd/sshd_config`:

```
PermitUserEnvironment yes
```

To use it, add `environment="SSH_USER=<SSH_USERNAME>"` ahead the SSH keys in your authorized_keys file:

```
environment="SSH_USER=a.test@example.com" ssh-ed25519 AAAAC3Nz...
```
