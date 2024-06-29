# conda-env

The plugin displays information of the created virtual container of conda and allows background theming.

To use it, add `conda-env` to the plugins array of your zshrc file:
```
plugins=(... conda-env)
```

The plugin creates a `conda_prompt_info` function that you can use in your
theme, which displays the basename of the current `$CONDA_DEFAULT_ENV`. It uses
two variables to control how that is shown:

- `ZSH_THEME_CONDA_PREFIX`: sets the prefix of the CONDA_DEFAULT_ENV.
Defaults to `[`.

- `ZSH_THEME_CONDA_SUFFIX`: sets the suffix of the CONDA_DEFAULT_ENV.
Defaults to `]`.
