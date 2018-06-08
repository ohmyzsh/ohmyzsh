# VS code

This plugin makes interaction between the command line and the code editor easier.

To start using it, add the `vscode` plugin to your `plugins` array in `~/.zshrc`:

```zsh
plugins=(... vscode)
```

## Common aliases

| Alias                        | Command                             | Description                                                                                                 |
| ---------------------------- | ----------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| vsc                          | code .                              | Open the current folder in VS code                                                                          |
| vsca `dir`                   | code --add `dir`                    | Add folder(s) to the last active window                                                                     |
| vscd `file` `file`           | code --diff `file` `file`           | Compare two files with each other.                                                                          |
| vscg `file:line[:character]` | code --goto `file:line[:character]` | Open a file at the path on the specified line and character position.                                       |
| vscn                         | code --new-window                   | Force to open a new window.                                                                                 |
| vscr                         | code --reuse-window                 | Force to open a file or folder in the last active window.                                                   |
| vscw                         | code --wait                         | Wait for the files to be closed before returning.                                                           |
| vscl `locale`                | code --locale `locale`              | The locale to use (e.g. en-US or zh-TW).                                                                    |
| vscu `dir`                   | code --user-data-dir `dir`          | Specifies the directory that user data is kept in. Can be used to open multiple distinct instances of Code. |

## Extensions alieases

| Alias                   | Command                                                          | Description                                                         |
| ----------------------- | ---------------------------------------------------------------- | ------------------------------------------------------------------- |
| vsce `dir`              | code --extensions-dir `dir`                                      | Set the root path for extensions.                                   |
| vscel                   | code --list-extensions                                           | List the installed extensions.                                      |
| vscsv                   | code --show-versions                                             | Show versions of installed extensions, when using --list-extension. |
| vscie `id or vsix-path` | code --install-extension `extension-id> or <extension-vsix-path` | Installs an extension.                                              |
| vscue `id or vsix-path` | code --uninstall-extension `id or vsix-path`                     | Uninstalls an extension.                                            |
| vscep `id`              | code --enable-proposed-api `extension-id`                        | Enables proposed api features for an extension.                     |

## Other options:

| Alias        | Command                   | Description                                                                                                           |
| ------------ | ------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| vscv         | code --verbose            | Print verbose output (implies --wait).                                                                                |
| vscl `level` | code --log `level`        | Log level to use. Default is 'info'. Allowed values are 'critical', 'error', 'warn', 'info', 'debug', 'trace', 'off'. |
| vscs         | code --status             | Print process usage and diagnostics information.                                                                      |
| vscp         | code --performance        | Start with the 'Developer: Startup Performance' command enabled.                                                      |
| vscps        | code --prof-startup       | Run CPU profiler during startup                                                                                       |
| vsced        | code --disable-extensions | Disable all installed extensions.                                                                                     |
| vscgd        | code --disable-gpu        | Disable GPU hardware acceleration.                                                                                    |
| vscul        | code --upload-logs        | Uploads logs from current session to a secure endpoint.                                                               |
| vscmm        | code --max-memory         | Max memory size for a window (in Mbytes).                                                                             |
