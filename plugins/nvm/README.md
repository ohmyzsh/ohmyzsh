# nvm plugin

This plugin adds autocompletions for [nvm](https://github.com/nvm-sh/nvm) — a Node.js version manager.
It also automatically sources nvm, so you don't need to do it manually in your `.zshrc`.

To use it, add `nvm` to the plugins array of your zshrc file:

```zsh
plugins=(... nvm)
```

## Settings

- **`NVM_DIR`**: if you have installed nvm in a directory other than `$HOME/.nvm`, set and export `NVM_DIR`
  to be the directory where you installed nvm.
  
- **`NVM_HOMEBREW`**: if you installed nvm via Homebrew, in a directory other than `/usr/local/opt/nvm`, you
  can set `NVM_HOMEBREW` to be the directory where you installed it.
