# Bundler

- adds completion for basic bundler commands
- adds short aliases for common bundler commands
  - `be` aliased to `bundle exec`
  - `bl` aliased to `bundle list`
  - `bp` aliased to `bundle package`
  - `bo` aliased to `bundle open`
  - `bu` aliased to `bundle update`
  - `bi` aliased to `bundle install --jobs=<cpu core count>` (only for bundler `>= 1.4.0`)
- adds a wrapper for common gems:
  - looks for a binstub under `./bin/` and executes it (if present)
  - calls `bundle exec <gem executable>` otherwise

For a full list of *common gems* being wrapped by default please look at the `bundler.plugin.zsh` file.

## Configuration

Please use the exact name of the executable and not the gem name.

### Add additional gems to be wrapped

Add this before the plugin-list in your `.zshrc`:
```sh
BUNDLED_COMMANDS=(rubocop)
plugins=(... bundler ...)
```
This will add the wrapper for the `rubocop` gem (i.e. the executable).


### Exclude gems from being wrapped

Add this before the plugin-list in your `.zshrc`:
```sh
UNBUNDLED_COMMANDS=(foreman spin)
plugins=(... bundler ...)
```
This will exclude the `foreman` and `spin` gems (i.e. their executable) from being wrapped.

## Excluded gems

These gems should not be called with `bundle exec`. Please see [issue #2923](https://github.com/robbyrussell/oh-my-zsh/pull/2923) on GitHub for clarification.

`berks`
`foreman`
`mailcatcher`
`rails`
`ruby`
`spin`
