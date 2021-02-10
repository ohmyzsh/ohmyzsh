# Bundler

This plugin adds completion for basic bundler commands, as well as aliases and helper functions for
an easier experience with bundler.

To use it, add `bundler` to the plugins array in your zshrc file:

```zsh
plugins=(... bundler)
```

## Aliases

| Alias  | Command                              | Description                                                                              |
|--------|--------------------------------------|------------------------------------------------------------------------------------------|
| `ba`   | `bundle add`                         | Add gem to the Gemfile and run bundle install                                            |
| `bck`  | `bundle check`                       | Verifies if dependencies are satisfied by installed gems                                 |
| `bcn`  | `bundle clean`                       | Cleans up unused gems in your bundler directory                                          |
| `be`   | `bundle exec`                        | Execute a command in the context of the bundle                                           |
| `bi`   | `bundle install --jobs=<core_count>` | Install the dependencies specified in your Gemfile (using all cores in bundler >= 1.4.0) |
| `bl`   | `bundle list`                        | List all the gems in the bundle                                                          |
| `bo`   | `bundle open`                        | Opens the source directory for a gem in your bundle                                      |
| `bout` | `bundle outdated`                    | List installed gems with newer versions available                                        |
| `bp`   | `bundle package`                     | Package your needed .gem files into your application                                     |
| `bu`   | `bundle update`                      | Update your gems to the latest available versions                                        |

## Gem wrapper

The plugin adds a wrapper for common gems, which:

- Looks for a binstub under `./bin/` and executes it if present.
- Calls `bundle exec <gem>` otherwise.

Common gems wrapped by default (by name of the executable):

`annotate`, `cap`, `capify`, `cucumber`, `foodcritic`, `guard`, `hanami`, `irb`, `jekyll`, `kitchen`, `knife`, `middleman`, `nanoc`, `pry`, `puma`, `rackup`, `rainbows`, `rake`, `rspec`, `rubocop`, `shotgun`, `sidekiq`, `spec`, `spork`, `spring`, `strainer`, `tailor`, `taps`, `thin`, `thor`, `unicorn` and `unicorn_rails`.

### Settings

You can add or remove gems from the list of wrapped commands.
Please **use the exact name of the executable** and not the gem name.

#### Include gems to be wrapped (`BUNDLED_COMMANDS`)

Add this before the plugin list in your `.zshrc`:

```sh
BUNDLED_COMMANDS=(rubocop)
plugins=(... bundler ...)
```

This will add the wrapper for the `rubocop` gem (i.e. the executable).

#### Exclude gems from being wrapped (`UNBUNDLED_COMMANDS`)

Add this before the plugin list in your `.zshrc`:

```sh
UNBUNDLED_COMMANDS=(foreman spin)
plugins=(... bundler ...)
```

This will exclude the `foreman` and `spin` gems (i.e. their executable) from being wrapped.

### Excluded gems

These gems should not be called with `bundle exec`. Please see [issue #2923](https://github.com/ohmyzsh/ohmyzsh/pull/2923) on GitHub for clarification:

- `berks`
- `foreman`
- `mailcatcher`
- `rails`
- `ruby`
- `spin`
