# pass

This plugin provides completion for the [pass](https://www.passwordstore.org/) password manager.

To use it, add `pass` to the plugins array in your zshrc file.

```
plugins=(... pass)
```

## Configuration

### Multiple repositories

If you use multiple repositories, you can configure completion like this:
```zsh
compdef _pass workpass
zstyle ':completion::complete:workpass::' prefix "$HOME/work/pass"
workpass() {
  PASSWORD_STORE_DIR=$HOME/work/pass pass $@
}
```
