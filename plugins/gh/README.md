# GitHub CLI plugin

This plugin adds completion for the [GitHub CLI](https://cli.github.com/).

To use it, add `gh` to the plugins array in your zshrc file:

```zsh
plugins=(... gh)
```

## Clear cache

This plugin does take use of some caching. The completion script is generated
by the `gh` command itself (which makes this plugin version independent), and
saves that to `$ZSH/plugins/gh/_gh`.

After you update the `gh` command, those completions may be out of date.

This cache is automatically checked periodically once per 24h, so as a user of
this plugin you should not need to do anything. Just take notice that after an
update the completions may act strangely up to 24 hours after you've updated.

To clear the cache manually, run the following:

```zsh
rm -v $ZSH/plugins/gh/_gh $ZSH_CACHE_DIR/gh_version
```
