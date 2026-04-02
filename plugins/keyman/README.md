# keyman plugin

Provides convenient commands for managing SSH and GPG keys from the terminal.
Works on macOS, Linux (X11/Wayland), and WSL.

To enable it, add `keyman` to your plugins:

```zsh
plugins=(... keyman)
```

Then type `keyman` to see all available commands.

## Commands

### SSH

| Command | Description |
|---|---|
| `km-ssh-new [comment] [file] [type]` | Create a new SSH key (default: ed25519) |
| `km-ssh-ls` | List all SSH public keys in `~/.ssh` |
| `km-ssh-copy [pubkey_file]` | Copy a public key to clipboard |
| `km-ssh-rm <keyfile>` | Delete an SSH key pair |

### GPG

| Command | Description |
|---|---|
| `km-gpg-new` | Create a GPG key (interactive, via `gpg --full-generate-key`) |
| `km-gpg-quick-new "Name" "Email" [expiry]` | Create a GPG key non-interactively (ed25519, default 2y expiry) |
| `km-gpg-ls [-s\|--secret]` | List public keys, or secret keys with `-s` |
| `km-gpg-pub <id>` | Export a GPG public key (armored) |
| `km-gpg-priv <id>` | Export a GPG secret key (armored, with confirmation) |
| `km-gpg-copy <id>` | Copy a GPG public key to clipboard |
| `km-gpg-fp <id>` | Show a GPG key fingerprint |
| `km-gpg-rm <id>` | Delete a GPG key (secret + public) |

## Settings

**IMPORTANT: put these settings _before_ the line that sources oh-my-zsh.**

### `lang`

Set the UI language. Supported values: `en` (default), `zh`.

```zsh
zstyle :omz:plugins:keyman lang zh
```

### `debug`

Show a status message when the plugin loads:

```zsh
zstyle :omz:plugins:keyman debug true
```

### `default-ssh-type`

Set the default SSH key type for `km-ssh-new`. Supported values:
`ed25519` (default), `rsa`, `ecdsa`.

```zsh
zstyle :omz:plugins:keyman default-ssh-type rsa
```

## Examples

```zsh
# Create a default ed25519 key
km-ssh-new

# Create an RSA key with a custom comment and path
km-ssh-new "me@work" ~/.ssh/work_key rsa

# List all SSH keys
km-ssh-ls

# Copy the default public key to clipboard
km-ssh-copy

# Create a GPG key quickly
km-gpg-quick-new "John Doe" "john@example.com" 1y

# Export and copy a GPG public key
km-gpg-copy john@example.com
```

## Requirements

At least one of the following must be available:

- `ssh-keygen` -- for SSH key commands
- `gpg` -- for GPG key commands

For clipboard support, one of: `pbcopy` (macOS), `xclip` (Linux X11),
`wl-copy` (Linux Wayland), or `clip.exe` (WSL).
