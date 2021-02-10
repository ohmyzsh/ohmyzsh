# VS Code

This plugin provides useful aliases to simplify the interaction between the command line and VS Code or VSCodium editor.

To start using it, add the `vscode` plugin to your `plugins` array in `~/.zshrc`:

```zsh
plugins=(... vscode)
```

## Requirements

This plugin requires to have a flavour of VS Code installed and it's executable available in PATH.

You can install either:

* VS Code (code)
* VS Code Insiders (code-insiders)
* VSCodium (codium)

### MacOS
While Linux installations will add the executable to PATH, MacOS users might still have to do this manually:

[For VS Code and VS Code Insiders](https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line), open
the Command Palette via (F1 or ⇧⌘P) and type shell command to find the Shell Command:
> Shell Command: Install 'code' command in PATH

[For VSCodium](https://github.com/VSCodium/vscodium/blob/master/DOCS.md#how-do-i-open-vscodium-from-the-terminal), open
the Command Palette via (F1 or ⇧⌘P) and type shell command to find the Shell Command:
> Shell Command: Install 'codium' command in PATH

## Using multiple flavours

If for any reason, you ever require to use multiple flavours of VS Code i.e. VS Code (stable) and VS Code Insiders, you can 
manually specify the flavour's executable. Add the following line to the .zshrc file (between the `ZSH_THEME` and the `plugins=()` lines).
This will make the plugin use your manually defined executable.

```zsh
ZSH_THEME=...

# Choose between one [code, code-insiders or codium]
# The following line will make the plugin to open VS Code Insiders
# Invalid entries will be ignored, no aliases will be added
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
