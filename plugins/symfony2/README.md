# Symfony2

This plugin provides completion for [Symfony 2](https://symfony.com/), as well as aliases for frequent Symfony commands.

To use it add symfony2 to the plugins array in your zshrc file.

```bash
plugins=(... symfony2)
```

## Aliases

| Alias         | Command                      | Description                   |
|---------------|------------------------------|-------------------------------|
| `sf`          | php app/console              | Start the symfony console     |
| `sfcl`        | sf cache:clear               | Clear the cache               |
| `sfsr`        | sf server:run                | Run the dev server            |
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
