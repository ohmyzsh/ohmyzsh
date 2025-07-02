# EternalHist Plugin

A comprehensive command history management plugin for Oh My Zsh that extends beyond session boundaries, with support for cloud storage and remote synchronization.

## Overview

EternalHist builds upon the concept of persistent shell history by providing advanced search, storage, and synchronization capabilities. Unlike standard shell history that's limited to recent commands or single sessions, EternalHist maintains a comprehensive, searchable archive of your command history across all sessions and systems.

## Core Features

### 🔍 Advanced History Search
- **Multi-term search**: Search using multiple keywords with AND/OR logic
- **Case-insensitive search**: Find commands regardless of case
- **Regex support**: Use regular expressions for complex pattern matching
- **Context search**: Find commands with surrounding context
- **Date/time filtering**: Search within specific time ranges
- **Frequency analysis**: Find most-used commands and patterns

### 💾 Persistent Storage
- **Local eternal history**: Maintains `~/.eternal_history` file
- **Session deduplication**: Prevents duplicate entries across sessions
- **Metadata tracking**: Stores timestamp, working directory, exit status
- **Compression support**: Optional compression for large history files
- **Backup management**: Automatic rotation and backup of history files

### ☁️ Cloud & Remote Storage Support
- **Multi-provider support**: Works with various cloud storage services
- **Environment variable configuration**: Flexible setup via env vars
- **Sync on demand**: Manual or automatic synchronization
- **Conflict resolution**: Handles merge conflicts across devices
- **Encryption support**: Optional encryption for sensitive command history

## Environment Variables

### Storage Location Configuration
```bash
# Local storage (default: ~/.eternal_history)
export ETERNALHIST_LOCAL_FILE="$HOME/.eternal_history"

# Multi-remote filesystem support
export ETERNALHIST_REMOTES="primary,backup,work,personal"  # Comma-separated list of remote names
export ETERNALHIST_DEFAULT_REMOTE="primary"                # Default remote for operations
export ETERNALHIST_SYNC_ALL_REMOTES="true"                # Sync with all configured remotes
```

### Per-Remote Configuration Pattern
Each remote is configured using the pattern `ETERNALHIST_<REMOTE_NAME>_<SETTING>`:

#### Primary Remote Example (Dropbox)
```bash
export ETERNALHIST_PRIMARY_PROVIDER="dropbox"
export ETERNALHIST_PRIMARY_PATH="/Apps/EternalHist/history"
export ETERNALHIST_PRIMARY_AUTH_TOKEN="your_dropbox_token"
export ETERNALHIST_PRIMARY_ENABLED="true"
export ETERNALHIST_PRIMARY_PRIORITY="1"                    # Sync order priority
```

#### Backup Remote Example (S3)
```bash
export ETERNALHIST_BACKUP_PROVIDER="s3"
export ETERNALHIST_BACKUP_BUCKET="my-eternalhist-bucket"
export ETERNALHIST_BACKUP_PATH="history/eternal_history"
export ETERNALHIST_BACKUP_REGION="us-west-2"
export ETERNALHIST_BACKUP_ACCESS_KEY="your_access_key"
export ETERNALHIST_BACKUP_SECRET_KEY="your_secret_key"
export ETERNALHIST_BACKUP_ENABLED="true"
export ETERNALHIST_BACKUP_PRIORITY="2"
```

#### Work Remote Example (SSH Server)
```bash
export ETERNALHIST_WORK_PROVIDER="ssh"
export ETERNALHIST_WORK_HOST="work-server.company.com"
export ETERNALHIST_WORK_USER="username"
export ETERNALHIST_WORK_PATH="/home/username/.shared_eternal_history"
export ETERNALHIST_WORK_SSH_KEY="$HOME/.ssh/work_key"
export ETERNALHIST_WORK_PORT="22"
export ETERNALHIST_WORK_ENABLED="true"
export ETERNALHIST_WORK_PRIORITY="3"
```

#### Personal Remote Example (Google Drive)
```bash
export ETERNALHIST_PERSONAL_PROVIDER="gdrive"
export ETERNALHIST_PERSONAL_PATH="/EternalHist/personal_history"
export ETERNALHIST_PERSONAL_CLIENT_ID="your_client_id"
export ETERNALHIST_PERSONAL_CLIENT_SECRET="your_client_secret"
export ETERNALHIST_PERSONAL_REFRESH_TOKEN="your_refresh_token"
export ETERNALHIST_PERSONAL_ENABLED="true"
export ETERNALHIST_PERSONAL_PRIORITY="4"
```

### Multi-Remote Sync Strategies
```bash
# Sync behavior across remotes
export ETERNALHIST_SYNC_STRATEGY="all"           # all, priority, selective, round-robin
export ETERNALHIST_SYNC_TIMEOUT="30"             # Timeout per remote (seconds)
export ETERNALHIST_SYNC_RETRY_COUNT="3"          # Retry failed syncs
export ETERNALHIST_SYNC_PARALLEL="true"          # Sync remotes in parallel
export ETERNALHIST_SYNC_CONFLICT_RESOLUTION="merge" # merge, latest, manual, skip
```

### Synchronization Settings
```bash
# Auto-sync behavior
export ETERNALHIST_AUTO_SYNC="true"           # Enable automatic sync
export ETERNALHIST_SYNC_INTERVAL="300"        # Sync every 5 minutes
export ETERNALHIST_SYNC_ON_EXIT="true"        # Sync when shell exits

# Conflict resolution
export ETERNALHIST_MERGE_STRATEGY="timestamp" # timestamp, interactive, local, remote
export ETERNALHIST_BACKUP_CONFLICTS="true"    # Keep conflicted versions
```

### Search and Display Options
```bash
# Search behavior
export ETERNALHIST_SEARCH_LIMIT="100"         # Max results to display
export ETERNALHIST_SEARCH_CONTEXT="2"         # Lines of context around matches
export ETERNALHIST_CASE_SENSITIVE="false"     # Case sensitivity for searches

# Display formatting
export ETERNALHIST_SHOW_TIMESTAMPS="true"     # Show when commands were run
export ETERNALHIST_SHOW_DIRECTORIES="true"    # Show working directory
export ETERNALHIST_SHOW_EXIT_STATUS="false"   # Show command exit codes
export ETERNALHIST_COLOR_OUTPUT="true"        # Colorize search results
```

### Security and Privacy
```bash
# Encryption
export ETERNALHIST_ENCRYPT="true"             # Encrypt history files
export ETERNALHIST_ENCRYPTION_KEY_FILE="$HOME/.eternalhist.key"

# Privacy filters
export ETERNALHIST_EXCLUDE_PATTERNS="password,secret,token,key,api"
export ETERNALHIST_PRIVATE_MODE="false"       # Disable history collection
export ETERNALHIST_MAX_COMMAND_LENGTH="500"   # Truncate very long commands
```

## Commands

### Default Search Behavior
```bash
eternalhist <search_terms...>          # Search eternal history (default behavior)
eternalhist                             # Show recent eternal history
```

### Core History Management
```bash
eternalhist add [command]               # Add command to eternal history
eternalhist remove <pattern>            # Remove matching commands (planned)
eternalhist clear                       # Clear all eternal history
eternalhist show [--limit N]            # Display eternal history
eternalhist stats                       # Show usage statistics
```

### Search with Escape Mechanism
```bash
eternalhist \<command_name> [terms...]  # Search for command names using backslash escape
eternalhist \add file                   # Search for "add file" (not the add command)
eternalhist \sync server                # Search for "sync server" (not the sync command)
eternalhist \clear cache                # Search for "clear cache" (not the clear command)
```

### Cloud & Remote Operations
```bash
# Multi-remote operations
eternalhist sync [remote_name]          # Sync with specific remote or all remotes
eternalhist push [remote_name]          # Upload to specific remote or all remotes
eternalhist pull [remote_name]          # Download from specific remote
eternalhist status [remote_name]        # Show sync status for remotes

# Remote management
eternalhist remotes list                # List all configured remotes
eternalhist remotes add <name>          # Add new remote configuration
eternalhist remotes remove <name>       # Remove remote configuration
eternalhist remotes test <name>         # Test remote connection
eternalhist remotes enable <name>       # Enable remote for sync
eternalhist remotes disable <name>      # Disable remote from sync

# Advanced multi-remote operations
eternalhist merge <file>                # Merge external history file
eternalhist backup [--remotes list]     # Create backup on specified remotes
eternalhist restore <backup> [remote]   # Restore from backup on specific remote
eternalhist replicate <from> <to>       # Copy history from one remote to another
```

### Advanced Features
```bash
eternalhist export [--format json|csv] # Export history in various formats
eternalhist import <file>               # Import history from file
eternalhist dedupe                      # Remove duplicate entries
eternalhist analyze                     # Analyze command patterns and usage
eternalhist config                      # Interactive configuration setup
eternalhist encrypt                     # Encrypt existing history file
eternalhist decrypt                     # Decrypt history file
```

## Installation

1. Add `eternalhist` to your plugins list in `~/.zshrc`:
   ```bash
   plugins=(... eternalhist)
   ```

2. Configure environment variables in `~/.zshrc` or `~/.zprofile`:
   ```bash
   # Basic configuration
   export ETERNALHIST_CLOUD_PROVIDER="dropbox"
   export ETERNALHIST_AUTO_SYNC="true"
   ```

3. Reload your shell or run:
   ```bash
   source ~/.zshrc
   ```

## Usage Examples

### Basic Search (Default Behavior)
```bash
# Search for git commands (no "search" keyword needed)
eternalhist git

# Search for multiple terms (AND logic)
eternalhist git commit push

# Search with regex
eternalhist "npm (install|update)"

# Search for command names that conflict with eternalhist commands
eternalhist \add file         # Search for "add file" commands
eternalhist \sync backup      # Search for "sync backup" commands
eternalhist \show details     # Search for "show details" commands
```

### Multi-Remote Synchronization
```bash
# One-time multi-remote setup
eternalhist config

# Sync with all configured remotes
eternalhist sync

# Sync with specific remote
eternalhist sync primary

# Sync with multiple specific remotes
eternalhist sync primary,backup

# Check status of all remotes
eternalhist status

# Check status of specific remote
eternalhist status work
```

### Advanced Usage
```bash
# Export monthly command report
eternalhist export --format csv --from "2024-01-01" --to "2024-01-31"

# Find most used commands
eternalhist analyze --top 10

# Backup before major changes
eternalhist backup --compress
```

## Integration with Existing `ht` Function

The plugin maintains full backward compatibility with your existing `ht` function. The `ht` command now uses `eternalhist` search functionality while preserving the same interface:

```bash
# These work exactly as before
ht git commit                    # Search for git commit commands
ht docker run                    # Search for docker run commands

# But now you can also use the more direct syntax
eternalhist git commit           # Same functionality, no "search" needed
eternalhist docker run           # Direct search without command prefix
```

## Cloud Provider Support

### Planned Integrations
- **Dropbox**: Via Dropbox API or mounted filesystem
- **Google Drive**: Via Google Drive API or rclone
- **iCloud**: Via iCloud Drive folder
- **OneDrive**: Via OneDrive API or mounted filesystem  
- **Amazon S3**: Via AWS CLI or S3 API
- **Custom SSH**: Via SCP/SFTP to any SSH server
- **Git repositories**: Version-controlled history storage

### Security Considerations
- All cloud uploads can be encrypted before transmission
- Support for client-side encryption keys
- Optional anonymization of sensitive commands
- Configurable exclude patterns for private data

## Development Roadmap

- [ ] Core history management functions
- [ ] Local file operations and search
- [ ] Cloud storage provider integrations
- [ ] Encryption and security features
- [ ] Advanced analytics and reporting
- [ ] Interactive configuration wizard
- [ ] Multi-device conflict resolution
- [ ] Integration with popular cloud services

## Contributing

This plugin is under active development. Contributions welcome for:
- Additional cloud provider integrations
- Enhanced search algorithms
- Security improvements
- Documentation and examples
- Testing across different environments

## License

MIT License - See LICENSE file for details.