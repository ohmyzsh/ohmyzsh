# NVM plugin

## Description

This plugin provides load nvm if it exists and when the .nvmrc file exists in your directory, it will download the described node version.

To start using it:
  * Add the `ZSH_NVM_AUTOLOAD=true` at the beginning of the file `~/.zshrc`
  * Add `nvm` plugin to your plugins array in `~/.zshrc`

```zsh
ZSH_NVM_AUTOLOAD=true
# ...
plugins=(... nvm)
```