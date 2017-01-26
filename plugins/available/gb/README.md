# `gb` plugin

> A project based build tool for the Go programming language.

See https://getgb.io for the full `gb` documentation

* * * *

- Adds completion support for all `gb` commands.
- Also supports completion for the [`gb-vendor` plugin](https://godoc.org/github.com/constabulary/gb/cmd/gb-vendor).

To use it, add `gb` to your plugins array:
```sh
plugins=(... gb)
```

## Caveats

The `git` plugin defines an alias `gb` that usually conflicts with the `gb` program.
If you're having trouble with it, remove it by adding `unalias gb` at the end of your
zshrc file.
