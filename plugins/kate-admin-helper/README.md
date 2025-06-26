# kate-admin-helper

This plugin provides an automatic privilege elevation helper for **Kate** (KDE text editor) when opening files in zsh.

When opening files that the user does not have write access to, the plugin automatically uses the `admin://` KIO protocol, allowing **Kate** to request privilege elevation via Polkit.  
This avoids running the entire **Kate** process as root and follows modern KDE security practices.

If privilege elevation is needed, a message will be shown, and the user will be prompted to authenticate with their password through Polkit.

## Installation

Add `kate-admin-helper` to your plugin list in `~/.zshrc`:

```zsh
plugins=(
  ...
  kate-admin-helper
)
```

## Usage

Open files as usual:

```zsh
kate /etc/hosts
kt /etc/fstab /etc/ssh/sshd_config
```

If the file requires elevated privileges to edit, it will be opened automatically with `admin://`.  
A colored message will inform you that privilege elevation is needed, and a Polkit prompt will ask for your password.

The `kt` command is also available and behaves the same way.

## Requirements

- **Kate** installed
- **kio-admin** installed
- A running **Polkit authentication agent** (e.g., `polkit-kde-agent-5` or `polkit-kde-agent-6`)
- `pkexec` available to create new files if needed
