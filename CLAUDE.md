# CLAUDE.md - Oh My Zsh Framework

This is the Oh My Zsh repository - a popular open-source framework for managing Zsh shell configurations.

## Repository Overview
- **Purpose**: Framework for managing Zsh configurations with plugins and themes
- **Structure**: Contains plugins, themes, tools, and library files for Zsh customization
- **Main files**: Installation scripts, update tools, plugin system, theme system

## Key Commands and Scripts
- `omz update` - Update Oh My Zsh to latest version
- `$ZSH/tools/upgrade.sh` - Direct upgrade script for automation
- `uninstall_oh_my_zsh` - Remove Oh My Zsh completely
- `$ZSH/tools/install.sh` - Installation script
- `$ZSH/tools/uninstall.sh` - Uninstallation script
- DO NOT ever `git add`, `git rm` or `git commit` code. Allow the Claude user to always manually review git changes. `git mv` is permiitted and inform the developer.
- **Operating outside of local repository (with .git/ directoryr oot)**: Not permitted and any file or other operations require user approval and notification

## Configuration
- Main config file: `~/.zshrc`
- Installation directory: `~/.oh-my-zsh` (customizable via `$ZSH` variable)
- Custom directory: `~/.oh-my-zsh/custom/` for user customizations

## Development Workflow
- Plugins located in `plugins/` directory
- Themes located in `themes/` directory  
- Library files in `lib/` directory
- Tools and utilities in `tools/` directory
- Custom plugins/themes go in `custom/` directory
- **New plugin**: `eternalhist` plugin added to `plugins/eternalhist/` for advanced persistent command history with multi-remote sync

## Testing
- No specific test commands found - check individual plugin READMEs
- Manual testing via shell usage and configuration changes

## Important Notes
- This is a shell framework, not a traditional application
- Changes require sourcing `~/.zshrc` or opening new terminal
- Plugin and theme changes require editing `~/.zshrc` configuration
- Uses Git for updates and version management
