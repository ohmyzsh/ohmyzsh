# npx plugin

## Deprecation

Since npm v7, `npx` has been moved to `npm exec`. With the move, [the `--shell-auto-fallback` argument
for `npx` has been removed](https://github.com/npm/cli/blob/v7.0.0/docs/content/cli-commands/npm-exec.md#compatibility-with-older-npx-versions):

> Shell fallback functionality is removed, as it is not advisable.

When using npm v7, you'll get this error:

> npx: the --shell-auto-fallback argument has been removed

If you get this error, just disable the plugin by removing it from the plugins array in your zshrc file.
This plugin will no longer be maintained and will be removed in the future, when the older `npx` versions
are no longer available.
