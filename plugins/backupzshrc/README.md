# Oh My Zsh Backup Plugin

This plugin provides a convenient way to back up your `~/.zshrc` file locally and to a GitHub repository. It automatically detects changes in the `.zshrc` file, commits them with a timestamped message, and pushes changes to the specified GitHub repository. If you ever rm your zshrc, simply go to your Github repo and check it out.

## Dependencies
1. Locally installed git with a git config for pulling the repo url and username
2. A repo in Github https://github.com/yourusername/oh-my-zsh-backup
    Example: https://github.com/yourusername/oh-my-zsh-backup
3. Push privileges configured to the main/master origin branch
4. Create directory privileges for this script - create "$HOME/projects/backups" manually otherwise

## Installation

1. Clone this repository into your Oh My Zsh custom plugins directory:

   ```bash
   git clone https://github.com/yourusername/oh-my-zsh-backup ~/.oh-my-zsh/custom/plugins/backup
   ```

2. Add `backup` to the plugins array in your `~/.zshrc` file:

   ```bash
   plugins=(... backup)
   ```

3. Restart your terminal.

## Usage

Simply open your terminal or source your `~/.zshrc` file, and the backup will be triggered automatically. Any changes detected in `~/.zshrc` will be backed up to the specified GitHub repository.

## Configuration

### GitHub Username

If your GitHub username is not already set globally, the plugin will prompt you to enter it the first time you run it. Alternatively, you can set it manually using:

```bash
git config --global user.name "Your Username"
```

### Branch

By default, the plugin pushes changes to the branch specified GitHub repository is checked out to locally in the "$HOME/projects/backups" backup directory. You can change the target branch by checking out to a new branch in the backup directory.

## Contributions

Contributions are welcome! If you encounter any issues or have suggestions for improvements, please feel free to open an issue or submit a pull request on GitHub.

## License

This plugin is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
