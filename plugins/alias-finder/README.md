# alias-finder plugin

This plugin searches the defined aliases and outputs any that match the command inputted. This makes learning new aliases easier.

To use it, add `alias-finder` to the `plugins` array of your zshrc file:
```
plugins=(... alias-finder)
```

## Usage
To see if there is an alias defined for the command, pass it as an argument to `alias-finder`. This can also run automatically before each command you input - add `ZSH_ALIAS_FINDER_AUTOMATIC=true` to your zshrc if you want this.

### Options

You can also set this options along with `ZSH_ALIAS_FINDER_AUTOMATIC` environment variable. For example,`ZSH_ALIAS_FINDER_OPTIONS='-l'` will be parsed as `alias-finder -l`. 

> In order to clarify, let's say `alias a=abc` has source 'abc' and destination 'a'.

- Use `--longer` or `-l` to include aliases where the source is longer than the input (in other words, the source could contain the whole input).
- Use `--exact` or `-e` to avoid aliases where the source is shorter than the input (in other words, the source must be the same with the input).
- Use `--cheap` or `-c` to avoid aliases where the destination is longer than the input (in other words, the destination must be the shorter than the input).


