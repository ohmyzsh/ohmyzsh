# goenv

This plugin looks for [goenv](https://github.com/syndbg/goenv), a Simple Go-lang version
management system, and loads it if it's found.

To use it, add `goenv` to the plugins array in your zshrc file:

```zsh
plugins=(... goenv)
```

## Functions

- `goenv_prompt_info`: displays the Go-lang version in use by goenv; or the global Go-lang
  version, if goenv wasn't found.
