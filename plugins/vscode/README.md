# VS Code

This plugin makes interaction between the command line and the VS Code editor easier.

To start using it, add the `vscode` plugin to your `plugins` array in `~/.zshrc`:

```zsh
plugins=(... vscode)
```

## Requirements

To use VS Code in the terminal **in macOS**, first you need to install the `code` command in the PATH,
otherwise you might receive this message: `zsh: command not found: code`.

[As the docs say](https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line), open
the Command Palette via (F1 or ⇧⌘P) and type shell command to find the Shell Command:
> Install 'code' command in PATH

## VS Code Insiders

🍏 **If you are only using [VS Code Insiders](https://code.visualstudio.com/insiders/), the plugin will automatically bind to your Insiders installation.**

But, if you have both Stable and Insiders versions and want to configure the plugin to just use the Insiders version, add the following line in the oh-my-zsh settings section (between the `ZSH_THEME` and the `plugins=()` line). This will make the plugin use the Insiders version instead.

```zsh
ZSH_THEME=...

# Add this line to use code-insiders instead of code
VSCODE=code-insiders

plugins=(... vscode)

source $ZSH/oh-my-zsh.sh
```

## Common aliases

| Alias                   | Command                        | Description                                                                                                 |
| ----------------------- | ------------------------------ | ----------------------------------------------------------------------------------------------------------- |
| vsc                     | code .                         | Open the current folder in VS code                                                                          |
| vsca `dir`              | code --add `dir`               | Add folder(s) to the last active window                                                                     |
| vscd `file` `file`      | code --diff `file` `file`      | Compare two files with each other.                                                                          |
| vscg `file:line[:char]` | code --goto `file:line[:char]` | Open a file at the path on the specified line and character position.                                       |
| vscn                    | code --new-window              | Force to open a new window.                                                                                 |
| vscr                    | code --reuse-window            | Force to open a file or folder in the last active window.                                                   |
| vscw                    | code --wait                    | Wait for the files to be closed before returning.                                                           |
| vscu `dir`              | code --user-data-dir `dir`     | Specifies the directory that user data is kept in. Can be used to open multiple distinct instances of Code. |

## Extensions aliases

| Alias                   | Command                                                          | Description                       |
| ----------------------- | ---------------------------------------------------------------- | --------------------------------- |
| vsced `dir`             | code --extensions-dir `dir`                                      | Set the root path for extensions. |
| vscie `id or vsix-path` | code --install-extension `extension-id> or <extension-vsix-path` | Installs an extension.            |
| vscue `id or vsix-path` | code --uninstall-extension `id or vsix-path`                     | Uninstalls an extension.          |

## Other options:

| Alias        | Command                   | Description                                                                                                           |
| ------------ | ------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| vscv         | code --verbose            | Print verbose output (implies --wait).                                                                                |
| vscl `level` | code --log `level`        | Log level to use. Default is 'info'. Allowed values are 'critical', 'error', 'warn', 'info', 'debug', 'trace', 'off'. |
| vscde        | code --disable-extensions | Disable all installed extensions.                                                                                     |
