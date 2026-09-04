# keyman plugin

Provides a unified `keyman` command for managing SSH and GPG keys from the terminal.
Works on macOS, Linux (X11/Wayland), and WSL.

> **Relationship to other plugins:** The [`ssh-agent`](../ssh-agent) and
> [`gpg-agent`](../gpg-agent) plugins manage agent *daemons* (auto-starting,
> identity loading, forwarding). `keyman` focuses on key *lifecycle* — creating,
> listing, copying, and deleting keys. They are complementary and can be used
> together.

To enable it, add `keyman` to your plugins:

```zsh
plugins=(... keyman)
```

Then type `keyman help` to see all available commands.

## Requirements

At least one of the following must be available:

- `ssh-keygen` — for SSH key commands
- `gpg` — for GPG key commands

### Clipboard support

For clipboard commands (`keyman ssh copy`, `keyman gpg copy`), one of the tools
below must be installed:

| Platform        | Tool       | Notes                      |
| --------------- | ---------- | -------------------------- |
| macOS           | `pbcopy`   | Built-in                   |
| Linux (X11)     | `xclip`    | `apt install xclip`        |
| Linux (Wayland) | `wl-copy`  | `apt install wl-clipboard`  |
| WSL             | `clip.exe` | Built-in (Windows side)    |

## Commands

### SSH

| Command                                       | Description                             |
| --------------------------------------------- | --------------------------------------- |
| `keyman ssh new [comment] [file] [type]`      | Create a new SSH key (default: ed25519) |
| `keyman ssh ls`                               | List all SSH public keys in `~/.ssh`    |
| `keyman ssh copy [pubkey_file]`               | Copy a public key to clipboard          |
| `keyman ssh rm <keyfile>`                     | Delete an SSH key pair                  |

### GPG

| Command                                            | Description                                                     |
| -------------------------------------------------- | --------------------------------------------------------------- |
| `keyman gpg new`                                   | Create a GPG key (interactive, via `gpg --full-generate-key`)   |
| `keyman gpg quick-new "Name" "Email" [expiry]`     | Create a GPG key non-interactively (ed25519, default 2y expiry) |
| `keyman gpg ls [-s\|--secret]`                     | List public keys, or secret keys with `-s`                      |
| `keyman gpg pub <id>`                              | Export a GPG public key (armored)                               |
| `keyman gpg priv <id>`                             | Export a GPG secret key (armored, with confirmation)            |
| `keyman gpg copy <id>`                             | Copy a GPG public key to clipboard                              |
| `keyman gpg fp <id>`                               | Show a GPG key fingerprint                                      |
| `keyman gpg rm <id>`                               | Delete a GPG key (secret + public)                              |

### General

| Command        | Description       |
| -------------- | ----------------- |
| `keyman help`  | Show help message |

## Tab Completion

All commands support multi-level Zsh tab completion:

```
keyman <TAB>        →  ssh | gpg | help
keyman ssh <TAB>    →  new | ls | copy | rm
keyman gpg <TAB>    →  new | quick-new | ls | pub | priv | copy | fp | rm
```

At the argument level:

- **`keyman ssh new`** — completes key types (`ed25519`, `rsa`, `ecdsa`) and file paths
- **`keyman ssh copy`** — completes `~/.ssh/*.pub` files
- **`keyman ssh rm`** — completes private key files in `~/.ssh`
- **`keyman gpg ls`** — completes `--secret` / `-s` options
- **`keyman gpg quick-new`** — completes common expiry values (`1y`, `2y`, `3y`, `5y`, `0`)
- **`keyman gpg pub`**, **`priv`**, **`copy`**, **`fp`**, **`rm`** — complete GPG key IDs and emails from your keyring

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

Set the default SSH key type for `keyman ssh new`. Supported values:
`ed25519` (default), `rsa`, `ecdsa`.

```zsh
zstyle :omz:plugins:keyman default-ssh-type rsa
```

## Examples

```zsh
# Create a default ed25519 key
keyman ssh new

# Create an RSA key with a custom comment and path
keyman ssh new "me@work" ~/.ssh/work_key rsa

# List all SSH keys
keyman ssh ls

# Copy the default public key to clipboard
keyman ssh copy

# Delete an SSH key
keyman ssh rm ~/.ssh/id_ed25519

# Create a GPG key interactively
keyman gpg new

# Create a GPG key quickly
keyman gpg quick-new "John Doe" "john@example.com" 1y

# List GPG secret keys
keyman gpg ls --secret

# Export and copy a GPG public key
keyman gpg copy john@example.com

# Show GPG key fingerprint
keyman gpg fp john@example.com
```
