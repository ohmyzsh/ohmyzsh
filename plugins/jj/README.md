# jj - Jujutsu CLI

This plugin provides autocompletion for [jj](https://martinvonz.github.io/jj).

To use it, add `jj` to the plugins array of your zshrc file:

```zsh
plugins=(... jj)
```

## Prompt usage

Because `jj` has a very powerful [template syntax](https://martinvonz.github.io/jj/latest/templates/), this
plugin only exposes a convenience function `jj_prompt_template` to read information from the current change.
It is basically the same as `jj log --no-graph -r @ -T $1`:

```sh
_my_theme_jj_info() {
  jj_prompt_template 'self.change_id().shortest(3)'
}

PROMPT='$(_my_theme_jj_info) $'
```

`jj_prompt_template` escapes `%` signs in the output. Use `jj_prompt_template_raw` if you don't want that
(e.g. to colorize the output).

However, because `jj` can be used inside a Git repository, some themes might clash with it. Generally, you can
fix it with a wrapper function that tries `jj` first and then falls back to `git` if it didn't work:

```sh
_my_theme_vcs_info() {
  jj_prompt_template 'self.change_id().shortest(3)' \
  || git_prompt_info
}

PROMPT='$(_my_theme_vcs_info) $'
```

You can find an example
[here](https://github.com/nasso/omzsh/blob/e439e494f22f4fd4ef1b6cb64626255f4b341c1b/themes/sunakayu.zsh-theme).

### Performance

Sometimes `jj` can be slower than `git`.

If you feel slowdowns, you can try adding `ZSH_THEME_JJ_IGNORE_WORKING_COPY=1` to your theme, which will add
`--ignore-working-copy` to all calls made to `jj`. The downside here is that your prompt might stay outdated
until the next time `jj` gets a chance to _not_ ignore the working copy.

If you prefer to keep your prompt always up-to-date but still don't want to _feel_ the slowdown, you can make
your prompt asynchronous. This plugin doesn't do this automatically so you'd have to hack your theme a bit for
that.

## See Also

- [martinvonz/jj](https://github.com/martinvonz/jj)

## Contributors

- [nasso](https://github.com/nasso) - Plugin Author
