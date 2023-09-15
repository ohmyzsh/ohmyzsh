# alias-finder plugin

This plugin searches the defined aliases and outputs any that match the command inputted. This makes learning new aliases easier.

## Usage

To use it, add `alias-finder` to the `plugins` array of your zshrc file:
```
plugins=(... alias-finder)
```

To enable it for every single command, set zstyle in your `~/.zshrc`.

```zsh
# ~/.zshrc

zstyle ':omz:plugins:alias-finder' autoload yes # disabled by default
zstyle ':omz:plugins:alias-finder' longer yes # disabled by default
zstyle ':omz:plugins:alias-finder' exact yes # disabled by default
zstyle ':omz:plugins:alias-finder' cheaper yes # disabled by default
```

As you can see, options are also available with zstyle.

### Options

> In order to clarify, let's say `alias a=abc` has source 'abc' and destination 'a'.

- Use `--longer` or `-l` to include aliases where the source is longer than the input (in other words, the source could contain the whole input).
- Use `--exact` or `-e` to avoid aliases where the source is shorter than the input (in other words, the source must be the same with the input).
- Use `--cheaper` or `-c` to avoid aliases where the destination is longer than the input (in other words, the destination must be the shorter than the input).


