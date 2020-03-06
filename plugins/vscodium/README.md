# VS Codium Plugin

This plugin creates aliases for all VSCodium command line options.
To enable, add it to the `plugins` array inside your Zsh resources file in `~/.zshrc`.
Look for 'plugins=(', which is the name of the plugins array followed by a iquals sign and an open parenthesis to better match your search term, and add it to the end of the list. This can help to discover which line is it via your shell's terminal:

```
egrep -rn "^plugins\=\(" ~/.zshrc
```
This can put you on the right line (I am assuming nano, vi or vim):
```
"${EDITOR}" +$(egrep -rn "^plugins\=\(" ~/.zshrc | awk --field-separator ":" '{print $1}') ~/.zshrc
```
Then add:
```
plugins=(... vscodium)
```

## Requirements
Besides having Zsh and this plugin, you must install VSCodium for your OS following the guide from vscodium's site:
[Install section](https://vscodium.com/#install)

## Aliases that will be set
#### Non categorized
| Alias  | Original         | Usage | Description |
| -----  | ---------------- | ----- | ------------|
| vsc    | codium .  | vsc | Open current directory as a project  |
| vsc-   | codium -  | ps aux \| grep code \| vsc- | To read from stdin, append '-' (e.g. 'ps aux \| grep code \| codium -')  |

#### Options Aliases

| Alias | Original                  | Usage | Description |
| ----- | ------------------------- | ----- | ------------|
| vscd  | codium -d --diff          | vscd <file> <file> | Compare two files with each other. |
| vsca  | codium -a --add           | vsca <folder> | Add folder(s) to the last active window. |
| vscg  | codium -g --goto          | vscg <file:line[:character]> | Open a file at the path on the specified line and character position. |
| vscn  | codium -n --new-window    | vscn  | Force to open a new window. |
| vscr  | codium -r --reuse-window  | vscr  | Force to open a file or folder in an already opened window. |
| vscw  | codium -w --wait          | vscw  | Wait for the files to be closed before returning. |
| vscll | codium --locale           | vscll <locale> | The locale to use (e.g. en-US or zh-TW). |
| vscu  | codium --user-data-dir    | vscu <dir> | Specifies the directory that user data is kept in. Can be used to open multiple distinct instances of Code. |
| vscvv | codium -v --version       | vscvv | Print version. |
| vsch  | codium -h --help          | vsch  | Print usage. |
| vsct  | codium --telemetry        | vsct  | Shows all telemetry events which VS code collects. |
| vscdu | codium --folder-uri       | vscdu<uri> | Opens a window with given folder uri(s) |
| vscfu | codium --file-uri         | vscfu<uri> | Opens a window with given file uri(s) |

#### Extensions Aliases
| Alias | Original                  | Usage | Description |
| ----- | ------------------------- | ----- | ------------|
| vsced  | codium --extensions-dir <dir>  | vsced  <dir> | Set the root path for extensions. |
| vscle  | codium --list-extensions       | vscle  | List the installed extensions. |
| vscsv  | codium --show-versions         | vscsv  | Show versions of installed extensions, when using --list-extension. |
| vscc   | codium --category              | vscc   | Filters installed extensions by provided category, when using --list-extension. |
| vscie  | codium --install-extension     | vscie <extension-id \| path-to-vsix> | Installs or updates the extension. Use `--force` argument to avoid prompts. |
| vscue  | codium --uninstall-extension   | vscue  <extension-id> | Uninstalls an extension. |
| vscapi | codium --enable-proposed-api   | vscapi <extension-id> | Enables proposed API features for extensions. Can receive one or more extension IDs to enable individually. |

#### Troubleshooting
| Alias | Original                  | Usage | Description |
| ----- | ------------------------- | ----- | ------------|
| vscv    | codium --verbose                          | vscv  | Print verbose output (implies --wait). |
| vscl    | codium --log                              | vscl <level>  | Log level to use. Default is 'info'. Allowed values are 'critical', 'error', 'warn', 'info', 'debug', 'trace', 'off'. |
| vscs    | codium -s --status                        | vscs  | Print process usage and diagnostics information. |
| vscps   | codium --prof-startup                     | vscps  | Run CPU profiler during startup |
| vscde   | codium --disable-extensions               | vscde  | Disable all installed extensions. |
| vscdei  | codium --disable-extension                | vscdei <extension-id> | Disable an extension. |
| vsciei  | codium --inspect-extensions               | vsciei <port> | Allow debugging and profiling of extensions. Check the developer tools for the connection URI. |
| vscibe  | codium --inspect-brk-extensions           | vscibe <port> | Allow debugging and profiling of extensions with the extension host being paused after start. Check the developer tools for the connection URI. |
| vscdg   | codium --disable-gpu                      | vscdg | Disable GPU hardware acceleration. |
| vscmm   | codium --max-memory                       | vscmm | Max memory size for a window (in Mbytes). |
