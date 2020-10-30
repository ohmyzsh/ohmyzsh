# projen

This plugin provides some aliases for [projen](https://github.com/projen/projen)

To use it, make sure [projen](https://github.com/projen/projen) is installed, and add `projen` to the plugins array in your zshrc file.

```zsh
plugins=(... projen)
```

## Plugin commands

* `pj_install` installs the `npm` module globally

* `pj` runs `npx projen`

* `pjn` runs `projen new`

## Dependencies

As projen is an `npm` and/or `yarn` Node.js TypeScript application, it depends on the relevant packager to install itself
