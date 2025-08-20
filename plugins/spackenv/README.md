# spackenv

Based on the virtualenv plugin.

The plugin displays information of the created Spack environment and allows background theming.

To use it, add `spackenv` to the plugins array of your zshrc file:
```
plugins=(... spackenv)
```

The plugin creates a `spackenv_prompt_info` function that you can use in your theme, which displays
the basename of the current `$SPACK_ENV`. It uses two variables to control how that is shown:

- `ZSH_THEME_SPACKENV_PREFIX`: sets the prefix of the SPACK_ENV. Defaults to `[`.

- `ZSH_THEME_SPACKENV_SUFFIX`: sets the suffix of the SPACK_ENV. Defaults to `]`.
