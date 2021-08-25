# zsh-multipass

This plugin provides completion for [multipass](https://multipass.run), as well as aliases
for multipass commands.

To use it add `zsh-multipass` to the plugins array in your zshrc file.

```zsh
plugins=(... zsh-multipass)

## Aliases

mp="multipass"
mpla="multipass launch"
mpl="multipass list"
mpsp="multipass stop"
mpst="multipass start"
mps="multipass shell"
mpln="multipass launch --network en0 --network name=bridge0,mode=manual"
