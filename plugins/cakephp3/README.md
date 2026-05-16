# cakephp3 plugin

The plugin adds aliases and autocompletion for [cakephp3](https://book.cakephp.org/3.0/en/index.html).

To use it, add `cakephp3` to the plugins array of your zshrc file:
```
plugins=(... cakephp3)
```

## Aliases

| Alias     | Command                       |
|-----------|-------------------------------|
| c3        | `bin/cake`                    |
| c3cache   | `bin/cake orm_cache clear`    |
| c3migrate | `bin/cake migrations migrate` |
