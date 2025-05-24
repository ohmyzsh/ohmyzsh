# fzf

The `fzf` plugin automatically configures [fzf](https://github.com/hunegunn/fzf), a general-purpose command-line fuzzy finder. This plugin enables interactive fuzzy search, auto-completion, and key bindings for a more efficient shell experience.
It detects your platform and attempts to automatically source the necessart `fzf` scripts, enabling features like `CTRL-T`, `CTRL-R`, and `ALT-C`.

To use it, add `fzf` to the plugins array in your `.zshrc` file:

```zsh
plugins=(... fzf)
```
 > Make sure you have `fzf` installed before enabling this plugin.

## Configuration Options

All variables should be defined before Oh My Zsh is sourced in your `.zshrc` file.

### `FZF_BASE`

If `fzf` is installed in a non-standard location, you can manually specift the base installation directory by setting:

```zsh
export FZF_BASE=/path/to/fzf
```

The plugin will look for shell integration files under `$FZF_BASE/shell`, or `$FZF_BASE` directly.

### `FZF_DEFAULT_COMMAND`

This variable defines the default command used by `fzf` when there is no piped input (e.g., when used with `CTRL-T`).

You can cutomize it:

```zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exlude .git'
```

If not defined, the plugin will automatically set it to the first available tool in the following priority:

- [`fd`](https://github.com/sharkdp/fd)
- [`rg`](https://github.com/BurntSushi/ripgrep)
- [`ag`](https://github.com/ggreer/the_silver_searcher)

These tools allow for fast, filesystem-aware searches and greatly improve `fzf` performance.

### `DISABLE_FZF_AUTO_COMPLETION`

If you do not want `fzf` to override or enchance Zsh's auto-completion, disable it by setting:

```zsh
DISABLE_FZF_AUTO_COMPLETION="true"
```

Auto-completion provides fuzzy matches for commands, files, and directories.

### `DISABLE_FZF_KEY_BINDINGS`

To disable the key bindings provided by `fzf`, set:

```zsh
DISABLE_FZF_KEY_BINDINGS="true"
```

Key bindings enabled by default:
 - `CTRL-T`: Paste selected file path(s)
 - `CTRL-R`: Search command history
 - `ALT-C`: Change to selected directory

## Detection Logic

The plugin tries to detect and configure `fzf` from a variety of environments. It tries these in order:
1. Using `fzf --zsh` if `fzf` is a recent version (`>= 0.48.0`)
2. OpenBSD default paths
3. Debian-based distributions
4. OpenSUSE
5. Fedora
6. Cygwin
7. MacPorts
8. Manual fallback search paths:
    - `~/.fzf`
    - `~/.nix-profile/share/fzf`
    - `$XDG_DATA_HOME/fzf` (or `~/.local/share/fzf`)
    - `/usr/share/fzf`, `/usr/local/share/examples/fzf`, etc
    - Results of `fzf-share` or `brew --prefix fzf`
If none of these are successful, the plugin shows an error prompting you to set `FZF_BASE`.
