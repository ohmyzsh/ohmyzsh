# grunt plugin

This plugin adds completions for [grunt](https://github.com/gruntjs/grunt).

To use it, add `grunt` to the plugins array of your `.zshrc` file:
```zsh
plugins=(... grunt)
```

## Enable caching

If you want to use the cache, set the following in your `.zshrc`:
```zsh
zstyle ':completion:*' use-cache yes
```

## Settings

* Show grunt file path:
  ```zsh
  zstyle ':completion::complete:grunt::options:' show_grunt_path yes
  ```
* Cache expiration days (default: 7):
  ```zsh
  zstyle ':completion::complete:grunt::options:' expire 1
  ```
* Not update options cache if target gruntfile is changed.
  ```zsh
  zstyle ':completion::complete:grunt::options:' no_update_options yes
  ```

Note that if you change the zstyle settings, you should delete the cache file and restart zsh.

```zsh
$ rm ~/.zcompcache/grunt
$ exec zsh
```
