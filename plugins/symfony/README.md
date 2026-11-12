# Symfony

This plugin provides unified completion and aliases for [Symfony](https://symfony.com/) across all versions (Symfony 1.x, 2.x, 3.x, 4.x, 5.x, and 6+).

The plugin automatically detects your Symfony version and console location, using:
- Native completion for Symfony 6.2+ when available
- Legacy completion for older Symfony versions
- Automatic console detection (`bin/console`, `app/console`, `console`, or `symfony`)

To use it add `symfony` to the plugins array in your zshrc file.

```bash
plugins=(... symfony)
```

## Aliases

| Alias         | Command                      | Description                   |
|---------------|------------------------------|-------------------------------|
| `sf`          | Auto-detected console path   | Start the symfony console     |
| `sfcl`        | sf cache:clear               | Clear the cache               |
| `sfsr`        | sf server:run -vvv           | Run the dev server            |
| `sfcw`        | sf cache:warmup              | Use the Bundles warmer        |
| `sfroute`     | sf debug:router              | Show the different routes     |
| `sfcontainer` | sf debug:container           | List the different services   |
| `sfgb`        | sf generate:bundle           | Generate a bundle             |
| `sfgc`        | sf generate:controller       | Generate a controller         |
| `sfgcom`      | sf generate:command          | Generate a command            |
| `sfge`        | sf doctrine:generate:entity  | Generate an entity            |
| `sfsu`        | sf doctrine:schema:update    | Update the schema in Database |
| `sfdc`        | sf doctrine:database:create  | Create the Database           |
| `sfdev`       | sf --env=dev                 | Update environment to `dev`   |
| `sfprod`      | sf --env=prod                | Update environment to `prod`  |

## Supported Commands

The plugin provides completion for all of the following console commands:
- `sf` (alias)
- `bin/console`
- `app/console` 
- `console`
- `php bin/console`
- `php app/console`
- `php console`
- `php symfony`

## Migration from other Symfony plugins

This unified plugin replaces the need for separate `symfony2` and `symfony6` plugins. If you were previously using either of those plugins, you can simply replace them with this `symfony` plugin in your `.zshrc` file.
