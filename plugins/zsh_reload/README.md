# zsh_reload plugin

The zsh_reload plugin defines a function to reload the zsh session with
just a few keystrokes.

To use it, add `zsh_reload` to the plugins array in your zshrc file:

```zsh
plugins=(... zsh_reload)
```

## Usage

To reload the zsh session, just run `src`:

```zsh
$ vim ~/.zshrc  # enabled a plugin
$ src
re-compiling /home/user/.zshrc.zwc: succeeded
re-compiling /home/user/.oh-my-zsh/cache/zcomp-host.zwc: succeeded

# you now have a fresh zsh session. happy hacking!
```
