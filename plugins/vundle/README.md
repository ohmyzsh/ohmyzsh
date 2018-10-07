# Vundle plugin

This plugin adds functions to control [vundle](https://github.com/VundleVim/Vundle.vim) plug-in manager for vim.

To use it, add `vundle` to the plugins array in your zshrc file:

```zsh
plugins=(... vundle)
```

## Functions

| Function      | Usage           | Description                                                                |
|---------------|-----------------|----------------------------------------------------------------------------|
| vundle-init   | `vundle-init`   | Install vundle by cloning git repository into ~/.vim folder                |
| vundle        | `vundle`        | Install plugins set in .vimrc (equals `:PluginInstall`)                    |
| vundle-update | `vundle-update` | Update plugins set in .vimrc (equals `:PluginInstall!`)                    |
| vundle-clean  | `vundle-clean`  | Delete plugins that have been removed from .vimrc (equals `:PluginClean!`) |

