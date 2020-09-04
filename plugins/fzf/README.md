# fzf

This plugin enables [junegunn's fzf](https://github.com/junegunn/fzf) fuzzy auto-completion and key bindings

To use it, add `fzf` to the plugins array in your zshrc file:
```zsh
plugins=(... fzf)
```

## Settings

Add these before the `plugins=()` line in your zshrc file:

```zsh
# Set fzf installation directory path
# export FZF_BASE=/path/to/fzf/install/dir

# Uncomment to set the FZF_DEFAULT_COMMAND
# export FZF_DEFAULT_COMMAND='<your fzf default commmand>'

# Uncomment the following line to disable fuzzy completion
# DISABLE_FZF_AUTO_COMPLETION="true"

# Uncomment the following line to disable key bindings (CTRL-T, CTRL-R, ALT-C)
# DISABLE_FZF_KEY_BINDINGS="true"
```

| Setting                     | Example value              | Description                                                 |
|-----------------------------|----------------------------|-------------------------------------------------------------|
| FZF_BASE                    | `/path/to/fzf/install/dir` | Set fzf installation directory path (**export**)            |
| FZF_DEFAULT_COMMAND         | `fd --type f`              | Set default command to use when input is tty (**export**)   |
| DISABLE_FZF_AUTO_COMPLETION | `true`                     | Set whether to load fzf auto-completion                     |
| DISABLE_FZF_KEY_BINDINGS    | `true`                     | Set whether to disable key bindings (CTRL-T, CTRL-R, ALT-C) |
