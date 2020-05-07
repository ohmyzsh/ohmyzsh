# fzf

This plugin enables [junegunn's fzf](https://github.com/junegunn/fzf) fuzzy auto-completion and key bindings

```zsh
# Set fzf installation directory path
export FZF_BASE=/path/to/fzf/install/dir

# Uncomment the following line to disable fuzzy completion
# export DISABLE_FZF_AUTO_COMPLETION="true"

# Uncomment the following line to disable key bindings (CTRL-T, CTRL-R, ALT-C)
# export DISABLE_FZF_KEY_BINDINGS="true"

plugins=(
  ...
  fzf
)
```

The plugin will also set the `FZF_DEFAULT_COMMAND` environment variable based on which finder you have available.
You can override this on your `.zshrc`:
```zsh
export FZF_DEFAULT_COMMAND='<your fzf default commmand>'
unlet FZF_DEFAULT_COMMAND  # use default FZF command
```
