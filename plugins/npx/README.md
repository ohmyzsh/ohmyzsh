# NPX Plugin

> npx(1) -- execute npm package binaries. ([more info](https://github.com/npm/npx))

This plugin automatically registers npx command-not-found handler if `npx` exists in your `$PATH`.

To use it, add `npx` to the plugins array in your zshrc file:

```zsh
plugins=(.... npx)
```

## Note

The shell auto-fallback doesn't auto-install plain packages. In order to get it to install something, you need to add `@`:

```
➜  jasmine@latest # or just `jasmine@`
npx: installed 13 in 1.896s
Randomized with seed 54385
Started
```

It does it this way so folks using the fallback don't accidentally try to install regular typoes.

## Deprecation

Since npm v7, `npx` has been moved to `npm exec`. With the move, [the `--shell-auto-fallback` argument
for `npx` has been removed](https://github.com/npm/cli/blob/v7.0.0/docs/content/cli-commands/npm-exec.md#compatibility-with-older-npx-versions):

> Shell fallback functionality is removed, as it is not advisable.

When using npm v7, you'll get this error:

> npx: the --shell-auto-fallback argument has been removed

If you get this error, just disable the plugin by removing it from the plugins array in your zshrc file.
This plugin will no longer be maintained and will be removed in the future, when the older `npx` versions
are no longer available.
