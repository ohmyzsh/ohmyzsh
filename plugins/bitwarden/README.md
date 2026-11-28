# Bitwarden plugin

This plugin adds Zsh completions for whichever Bitwarden CLIs are installed:

- [Bitwarden CLI (`bw`)](https://bitwarden.com/help/cli/)
- [Bitwarden Secrets Manager CLI (`bws`)](https://bitwarden.com/help/secrets-manager-cli/)

To enable it, add `bitwarden` to the plugins array in your `.zshrc`:

```zsh
plugins=(... bitwarden)
```

Each installed CLI generates and refreshes its own completion cache in the
background when the plugin loads. The cache files are
`$ZSH_CACHE_DIR/completions/_bw` and `$ZSH_CACHE_DIR/completions/_bws`.
