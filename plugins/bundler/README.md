# Bundler

- Adds completion for basic bundler commands

## Aliases

| Alias  | Command             | Description                                               |
|--------|---------------------|-----------------------------------------------------------|
| `ba`   | `bundle add`        | Add gem to the Gemfile and run bundle install             |
| `be`   | `bundle exec`       | Execute a command in the context of the bundle            |
| `bl`   | `bundle list`       | List all the gems in the bundle                           |
| `bp`   | `bundle package`    | Package your needed .gem files into your application      |
| `bo`   | `bundle open`       | Opens the source directory for a gem in your bundle       |
| `bout` | `bundle outdated`   | List installed gems with newer versions available         |
| `bu`   | `bundle update`     | Update your gems to the latest available versions         |
| `bi`   | `bundle install`    | Install the dependencies specified in your Gemfile        |
| `bcn`  | `bundle clean`      | Cleans up unused gems in your bundler directory           |
| `bck`  | `bundle check`      | Verifies if dependencies are satisfied by installed gems  |

    
- Adds a wrapper for common gems:
  - Looks for a binstub under `./bin/` and executes it (if present)
  - Calls `bundle exec <gem executable>` otherwise

Common gems wrapped by default (by name of the executable):
`annotate`, `cap`, `capify`, `cucumber`, `foodcritic`, `guard`, `hanami`, `irb`, `jekyll`, `kitchen`, `knife`, `middleman`, `nanoc`, `pry`, `puma`, `rackup`, `rainbows`, `rake`, `rspec`, `rubocop`, `shotgun`, `sidekiq`, `spec`, `spork`, `spring`, `strainer`, `tailor`, `taps`, `thin`, `thor`, `unicorn` and `unicorn_rails`.

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

These gems should not be called with `bundle exec`. Please see [issue #2923](https://github.com/ohmyzsh/ohmyzsh/pull/2923) on GitHub for clarification.

`berks`
`foreman`
`mailcatcher`
`rails`
`ruby`
`spin`
