# fail2ban-client

## Description  

Zsh completion for the `fail2ban-client` command.  
This plugin provides:  

- Completion for subcommands (`start`, `restart`, `reload`, `stop`, `unban`, `status`, `set`, `get`, `add`, etc.)
- Dynamic completion of active jails  
- Contextual completion of options for `set` and `get` (e.g., `bantime`, `maxretry`, `ignoreip`, etc.)  
- Automatic handling of `sudo` if required  

## Installation

To use it, add **fail2ban** to the plugins array in your zshrc file:

```bash
plugins=(... fail2ban)
```

## Usage

Type `fail2ban-client <TAB>` to trigger completion.  
Examples:

```bash
fail2ban-client set <TAB>            # suggests jails  
fail2ban-client set sshd <TAB>       # suggests possible actions  
fail2ban-client get sshd <TAB>       # suggests available properties  
fail2ban-client status <TAB>         # suggests jails or the 'extended' option  
```

## Compatibility

- Zsh version 5.x or higher
- Works with or without root access (uses `sudo` if needed)
- Designed to be used as a plugin in Oh My Zsh  
