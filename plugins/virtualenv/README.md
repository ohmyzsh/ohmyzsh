# virtualenv

The plugin displays information of the created virtual container and allows background theming.

To use it, add `virtualenv` to the plugins array of your zshrc file:
```
plugins=(... virtualenv)
```

The plugin creates a `virtualenv_prompt_info` function that you can use in your
theme. It displays the prompt string set in the `$VIRTUAL_ENV_PROMPT`
environment variable. The `activate` scripts for most Python virtual environment
implementations set this variable to the value provided via the `--prompt`
option when creating the virtual environment, or the basename of the environment
directory if the option was not provided. For implementations that do not set
`$VIRTUAL_ENV_PROMPT`, the plugin will display the basename of the virtual
environment directory instead.

It uses two variables to control how that is shown:

- `ZSH_THEME_VIRTUALENV_PREFIX`: sets the prefix of the VIRTUAL_ENV. Defaults to `[`.

- `ZSH_THEME_VIRTUALENV_SUFFIX`: sets the suffix of the VIRTUAL_ENV. Defaults to `]`.
