# Proxmox Plugin

A convenient Oh My Zsh plugin for managing Proxmox Virtual Environment (PVE) from the command line. This plugin provides easy-to-use commands for common VM operations like listing, starting, stopping, and monitoring virtual machines through the Proxmox VE REST API.

## Features

- **VM Management**: List, start, stop, and gracefully shutdown VMs
- **Status Monitoring**: Check individual VM and cluster node status  
- **Tab Completion**: Auto-complete VM IDs for faster command execution
- **Colored Output**: Enhanced readability with color-coded status messages
- **Error Handling**: Clear error messages and configuration validation
- **Multiple Authentication**: Supports various Proxmox authentication realms

## Requirements

- **Proxmox VE Server**: Access to a Proxmox VE installation
- **Network Access**: HTTPS connectivity to your Proxmox server (port 8006)
- **Valid Credentials**: Proxmox user account with appropriate permissions
- **curl**: Command-line tool for API requests (usually pre-installed)

### Required Proxmox Permissions

Your Proxmox user needs at minimum:
- `VM.PowerMgmt` - To start/stop VMs
- `VM.Monitor` - To check VM status
- `Sys.Audit` - To list VMs and nodes

## Installation

1. Clone the Oh My Zsh repository or add this plugin to your existing installation:
   ```bash
   git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
   ```

2. Add `proxmox` to your plugins list in `~/.zshrc`:
   ```bash
   plugins=(git proxmox ... other-plugins)
   ```

3. Configure your Proxmox credentials by adding these environment variables to your `~/.zshrc`:
   ```bash
   export PROXMOX_HOST="proxmox.example.com"    # Your Proxmox server hostname/IP
   export PROXMOX_USER="root@pam"               # Username@realm
   export PROXMOX_PASSWORD="your-password"      # User password
   export PROXMOX_NODE="node1"                  # Optional: specific node name
   ```

4. Reload your shell configuration:
   ```bash
   source ~/.zshrc
   ```

## Configuration

### Environment Variables

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `PROXMOX_HOST` | Yes | Proxmox server hostname or IP | `proxmox.example.com` |
| `PROXMOX_USER` | Yes | Username with authentication realm | `root@pam` or `admin@pve` |
| `PROXMOX_PASSWORD` | Yes | User password | `your-secure-password` |
| `PROXMOX_NODE` | No | Specific node name (auto-detected if not set) | `pve-node1` |

### Authentication Realms

Common Proxmox authentication realms:
- `@pam` - Linux system users
- `@pve` - Proxmox VE authentication server
- `@ad` - Active Directory
- `@ldap` - LDAP server

## Usage

### Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `pve-list` | List all VMs with status | `pve-list` |
| `pve-start <vmid>` | Start a virtual machine | `pve-start 100` |
| `pve-stop <vmid>` | Force stop a virtual machine | `pve-stop 100` |
| `pve-shutdown <vmid>` | Gracefully shutdown a VM | `pve-shutdown 100` |
| `pve-status <vmid>` | Get detailed VM status | `pve-status 100` |
| `pve-cluster` | Show cluster nodes status | `pve-cluster` |
| `pve-help` | Display help information | `pve-help` |

### Command Aliases

For faster access, these short aliases are available:
- `pvels` → `pve-list`
- `pvestart` → `pve-start`
- `pvestop` → `pve-stop`
- `pvestatus` → `pve-status`
- `pvecluster` → `pve-cluster`

### Tab Completion

The plugin supports tab completion for VM IDs. Start typing a command and press `Tab` to auto-complete available VM IDs:

```bash
pve-start <Tab>    # Shows available VM IDs
pve-status 1<Tab>  # Completes VM IDs starting with 1
```

## Examples

### List all VMs
```bash
$ pve-list
Fetching VM list...
VMs on node pve-node1:
ID      Name            Status          Memory  CPUs
──────────────────────────────────────────────
100     ubuntu-web      running         2048MB  2
101     debian-db       stopped         4096MB  4
102     windows-ad      running         8192MB  4
```

### Start a VM
```bash
$ pve-start 101
Starting VM 101...
VM 101 start command sent successfully
```

### Check VM status
```bash
$ pve-status 100
Status for VM 100:
Status: running
Name: ubuntu-web
CPUs: 2
Memory: 2048MB
Uptime: 86400 seconds
```

### View cluster status
```bash
$ pve-cluster
Fetching cluster status...
Cluster Nodes:
Node            Status  CPU%    Memory% Uptime
──────────────────────────────────────────────
pve-node1       online  15.2%   45.8%   604800
pve-node2       online  8.7%    32.1%   604800
```

## Security Considerations

### Password Security
- **Never commit passwords to version control**
- Consider using a `.env` file that's git-ignored:
  ```bash
  # In ~/.zshrc
  source ~/.proxmox.env
  ```
  
- For enhanced security, use Proxmox API tokens instead of passwords:
  ```bash
  # Future enhancement - API token support planned
  export PROXMOX_TOKEN_ID="user@realm!token-name"
  export PROXMOX_TOKEN_SECRET="token-secret"
  ```

### Network Security
- The plugin connects via HTTPS (port 8006)
- SSL certificates are not strictly validated (`-k` flag in curl)
- Ensure your Proxmox server uses proper SSL certificates in production

## Troubleshooting

### Common Issues

**"Error: Please set PROXMOX_HOST, PROXMOX_USER, and PROXMOX_PASSWORD environment variables"**
- Solution: Make sure all required environment variables are set in your `~/.zshrc`

**"Error: Failed to connect to Proxmox server"**
- Check network connectivity: `curl -k https://your-proxmox-host:8006`
- Verify hostname/IP address is correct
- Ensure port 8006 is accessible

**"Error: Could not determine node"**
- Check your credentials are valid
- Verify user has permission to list nodes
- Set `PROXMOX_NODE` explicitly if auto-detection fails

**Tab completion not working**
- Ensure the plugin is properly loaded: `which pve-list`
- Try reloading your shell: `source ~/.zshrc`

### Debug Mode

For troubleshooting API calls, you can temporarily modify the curl commands to show more verbose output by adding `-v` flag.

## Contributing

This plugin welcomes contributions! Please:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-improvement`
3. Test your changes thoroughly
4. Submit a pull request with a clear description

### Planned Features
- API token authentication support
- Container (LXC) management
- Storage and backup operations
- Configuration file support
- More detailed VM information display

## License

This plugin is released under the same license as Oh My Zsh.
