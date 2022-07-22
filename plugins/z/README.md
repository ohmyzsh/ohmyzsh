# z - jump around

This plugin defines the [z command](https://github.com/rupa/z) that tracks your most visited directories and allows you to access them with very few keystrokes.

### Example
Assume that you have previously visited directory `~/.oh-my-zsh/plugins`. From any folder in your command line, you can quickly access it by using a regex match to this folder:

```bash
/usr/bin$ z plug  # Even 'z p' might suffice
~/.oh-my-zsh/plugins$
```

### Setup
To enable z, add `z` to your `plugins` array in your zshrc file:

```zsh
plugins=(... z)
```

### Further reading

For advanced usage and details of z, see [README](./README) (in man page format, copied from [rupa/z](https://github.com/rupa/z)).

