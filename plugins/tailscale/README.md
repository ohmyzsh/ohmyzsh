# Tailscale plugin

This plugin adds an alias for the [tailscale CLI](https://tailscale.com/kb/1080/cli/) on Mac systems.
On Windows and Linux systems this alias isn't necessary, since the `tailscale` binary is likely already already in $PATH.

To use the plugin, add `tailscale` to the plugins array in your zshrc file:

```zsh
plugins=(... tailscale)
```