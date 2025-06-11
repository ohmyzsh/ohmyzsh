# Magento 2 plugin

This plugin provides a powerful set of shortcuts, aliases, and utilities to simplify and enhance your Magento 2 development workflow in the command line.

## Installation

To use it, add `magento2` to the plugins array in your zshrc file:

```
plugins=(... magento2)
```

## Features

- Automatic Magento root directory detection
- Shorthand commands for common Magento 2 CLI operations
- Admin user management
- Database information retrieval
- System status overview
- Quick cache and temporary file cleanup
- Deployment and module management helpers

## Usage Guide

### Basic Commands

| Alias/Command | Description | Usage |
|---------------|-------------|-------|
| `m2` | Base Magento CLI command with unlimited memory | `m2 [command]` |
| `mg-cd` | Navigate to Magento root directory | `mg-cd` |
| `mg-set-root` | Set current directory as Magento root | `mg-set-root` |
| `mg-status` | Display comprehensive system status | `mg-status` |

### Cache Management

| Alias/Command | Description | Usage |
|---------------|-------------|-------|
| `m2cc` | Clean cache | `m2cc` |
| `m2cf` | Flush cache | `m2cf` |
| `mg-clean` | Remove temporary files and flush cache | `mg-clean` |

### Setup and Deployment

| Alias/Command | Description | Usage |
|---------------|-------------|-------|
| `m2setup` | Run setup:upgrade | `m2setup` |
| `m2dicom` | Compile Dependency Injection | `m2dicom` |
| `m2deploy` | Deploy static content | `m2deploy` |
| `m2st` | Full setup (upgrade, compile, deploy) | `m2st` |
| `mg-update` | Complete system update | `mg-update` |
| `mg-deploy-langs` | Deploy for specific languages | `mg-deploy-langs "en_US fr_FR"` |

### Mode Management

| Alias/Command | Description | Usage |
|---------------|-------------|-------|
| `m2mode` | Show current mode | `m2mode` |
| `m2dev` | Set developer mode | `m2dev` |
| `m2prod` | Set production mode | `m2prod` |

### Maintenance

| Alias/Command | Description | Usage |
|---------------|-------------|-------|
| `m2maint` | Check maintenance status | `m2maint` |
| `m2mainton` | Enable maintenance mode | `m2mainton` |
| `m2maintoff` | Disable maintenance mode | `m2maintoff` |

### Module Management

| Alias/Command | Description | Usage |
|---------------|-------------|-------|
| `m2module` or `m2mod` | List all modules and status | `m2module` |
| `m2enable` | Enable a module | `m2enable Vendor_Module` |
| `m2disable` | Disable a module | `m2disable Vendor_Module` |
| `mg-module` | Module management function | `mg-module enable Vendor_Module` |

### Indexing

| Alias/Command | Description | Usage |
|---------------|-------------|-------|
| `m2index` | Show indexer status | `m2index` |
| `m2indexr` | Reindex all indices | `m2indexr` |

### Admin User Management

| Alias/Command | Description | Usage |
|---------------|-------------|-------|
| `mg-admin-create` | Create admin user | `mg-admin-create [username] [email] [firstname] [lastname] [password]` |
| `mg-admin-password` | Change admin password | `mg-admin-password [username] [new_password]` |

### Database Information

| Alias/Command | Description | Usage |
|---------------|-------------|-------|
| `mg-db-info` | Show database connection info | `mg-db-info` |

### Logging

| Alias/Command | Description | Usage |
|---------------|-------------|-------|
| `m2log` | Tail system log | `m2log` |
| `m2elog` | Tail exception log | `m2elog` |
| `m2debug` | Tail debug log | `m2debug` |

## Example Workflows

### Initial Setup

```bash
# Navigate to your Magento project
cd ~/projects/my-magento-store

# Set as Magento root if not automatically detected
mg-set-root

# Check system status
mg-status

# Create admin user
mg-admin-create "admin" "admin@gmail.com" "Hanashiko" "Margin" "securepassword123"
```

### Development Workflow

```bash
# Switch to developer mode
m2dev

# Enable a custom module
m2enable MyCompany_CustomModule

# Update system after changes
mg-update

# Or individual steps:
m2setup       # Update database schema
m2dicom       # Compile code
m2deploy      # Deploy static content
m2indexr      # Reindex
```

### Cleanup Operations

```bash
# Quick cleanup of temporary files
mg-clean

# Or individual operations
m2cf          # Flush cache
```

### Deployment Preparation

```bash
# Switch to production mode
m2prod

# Deploy for multiple languages
mg-deploy-langs "en_US de_DE fr_FR"

# Enable maintenance mode before deployment
m2mainton
```

## Tips and Tricks

- Use `mg-cd` to quickly navigate to the Magento root from any subdirectory
- Run `mg-status` to get a comprehensive overview of your system
- Use tab completion with `m2` to explore available Magento CLI commands
- The `mg-update` command combines multiple setup steps into a single command
