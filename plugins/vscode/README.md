# VS Code

This plugin provides useful aliases to simplify interaction between the command line and VS Code, VSCodium, or Cursor.

To start using it, add the `vscode` plugin to your `plugins` array in `~/.zshrc`:

```zsh
plugins=(... vscode)
```

## Requirements

This plugin requires one of the supported editors to be installed and its executable to be available in `PATH`.

You can install one of the following:

- VS Code (`code`)
- VS Code Insiders (`code-insiders`)
- VSCodium (`codium`)
- Cursor (`cursor`)

### macOS

While Linux installations usually add the executable to `PATH`, macOS users might still have to do this manually:

[For VS Code and VS Code Insiders](https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line),
open the Command Palette with `F1` or `Shift+Cmd+P`, then search for the following command:

> Shell Command: Install 'code' command in PATH

[For VSCodium](https://github.com/VSCodium/vscodium/blob/master/DOCS.md#how-do-i-open-vscodium-from-the-terminal),
open the Command Palette with `F1` or `Shift+Cmd+P`, then search for the following command:

> Shell Command: Install 'codium' command in PATH

For Cursor, open the Command Palette with `F1` or `Cmd+Shift+P`, then search for the following command:

> Shell Command: Install 'cursor' command in PATH

## Choosing an editor

If you have multiple supported editors installed, e.g., VS Code (stable) and VS Code Insiders, you can manually
specify which executable the plugin should use. Add the following line to `~/.zshrc` between the `ZSH_THEME`
and `plugins=()` lines. This makes the plugin use your manually defined executable.

```zsh
ZSH_THEME=...

# Choose one of `code`, `code-insiders`, `codium`, or `cursor`.
# The following line makes the plugin open VS Code Insiders.
# Invalid entries are ignored and no aliases are added.
VSCODE=code-insiders

plugins=(... vscode)

source $ZSH/oh-my-zsh.sh
```

## Common aliases

| Alias                   | Command                        | Description                                                                                                 |
| ----------------------- | ------------------------------ | ----------------------------------------------------------------------------------------------------------- |
| vsc                     | code .                         | Open the current folder in VS Code                                                                          |
| vsc `[args ...]`        | code `[args ...]`              | Pass arguments through to VS Code, e.g., a file, folder, or CLI flags.                                      |
| vsca `dir`              | code --add `dir`               | Add one or more folders to the last active window.                                                          |
| vscd `file` `file`      | code --diff `file` `file`      | Compare two files with each other.                                                                          |
| vscg `file:line[:char]` | code --goto `file:line[:char]` | Open a file at the path on the specified line and character position.                                       |
| vscn                    | code --new-window              | Force opening in a new window.                                                                              |
| vscr                    | code --reuse-window            | Force opening a file or folder in the last active window.                                                   |
| vscw                    | code --wait                    | Wait for the files to be closed before returning.                                                           |
| vscu `dir`              | code --user-data-dir `dir`     | Specifies the directory where user data is stored. Can be used to open multiple distinct instances of Code. |
| vscp `profile`          | code --profile `profile`       | Specifies the profile to open Code with.                                                                    |

## Extension aliases

| Alias                       | Command                                        | Description                            |
| --------------------------- | ---------------------------------------------- | -------------------------------------- |
| vsced `dir`                 | code --extensions-dir `dir`                    | Set the root directory for extensions. |
| vscie `ext-id or vsix-path` | code --install-extension `ext-id or vsix-path` | Installs or updates an extension.      |
| vscue `ext-id`              | code --uninstall-extension `ext-id`            | Uninstalls an extension.               |

## Other options

| Alias        | Command                   | Description                              |
| ------------ | ------------------------- | ---------------------------------------- |
| vscv         | code --verbose            | Print verbose output (implies `--wait`). |
| vscl `level` | code --log `level`        | Log level to use. Default is `info`.     |
| vscde        | code --disable-extensions | Disable all installed extensions.        |
