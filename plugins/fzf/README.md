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
