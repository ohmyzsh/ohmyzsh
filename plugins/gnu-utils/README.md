# gnu-utils plugin

This plugin binds GNU coreutils to their default names, so that you don't have
to call them using their prefixed name, which starts with `g`. This is useful
in systems which don't have GNU coreutils installed by default, mainly macOS
or FreeBSD, which use BSD coreutils.

To use it, add `gnu-utils` to the plugins array in your zshrc file:
```zsh
plugins=(... gnu-utils)
```

The plugin works by changing the path that the command hash points to, so
instead of `ls` pointing to `/bin/ls`, it points to wherever `gls` is
installed.

Since `hash -rf` or `rehash` refreshes the command hashes, it also wraps
`hash` and `rehash` so that the coreutils binding is always done again
after calling these two commands.

Look at the source code of the plugin to see which GNU coreutils are tried
to rebind. Open an issue if there are some missing.

## Other methods

The plugin also documents two other ways to do this:

1. Using a function wrapper, such that, for example, there exists a function
named `ls` which calls `gls` instead. Since functions have a higher preference
than commands, this ends up calling the GNU coreutil. It has also a higher
preference over shell builtins (`gecho` is called instead of the builtin `echo`).

2. Using an alias. This has an even higher preference than functions, but they
could be overridden because of a user setting.

## Author

- [Sorin Ionescu](https://github.com/sorin-ionescu).
