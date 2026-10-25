# Bridgetown plugin

This plugin adds aliases for common [Bridgetown](https://www.bridgetownrb.com/) commands.

To use it, add `bridgetown` to the plugins array in your zshrc file:

```zsh
plugins=(... bridgetown)
```

## Aliases

Most aliases use the project's `bin/bridgetown` executable so the command runs with the Bridgetown version
locked in its `Gemfile`. The `br` and `brn` aliases use the globally installed executable and can be run
outside a Bridgetown project.

| Alias     | Command                      | Description                              |
| --------- | ---------------------------- | ---------------------------------------- |
| `br`      | `bridgetown`                 | Run the globally installed CLI           |
| `bra`     | `bin/bridgetown apply`       | Apply an automation                      |
| `brb`     | `bin/bridgetown build`       | Build the site                           |
| `brc`     | `bin/bridgetown console`     | Open the Bridgetown console              |
| `brclean` | `bin/bridgetown clean`       | Remove generated files and caches        |
| `brco`    | `bin/bridgetown configure`   | Apply a bundled configuration            |
| `brd`     | `bin/bridgetown deploy`      | Run the project's deployment task        |
| `brdev`   | `bin/bridgetown dev`         | Start the development server             |
| `bre`     | `bin/bridgetown esbuild`     | Manage the esbuild configuration         |
| `brh`     | `bin/bridgetown help`        | Show command help                         |
| `brn`     | `bridgetown new`             | Create a new Bridgetown site              |
| `brp`     | `bin/bridgetown plugins`     | Access plugin commands                    |
| `brpl`    | `bin/bridgetown plugins list` | List installed plugins                    |
| `brs`     | `bin/bridgetown start`       | Start the development server             |
| `brt`     | `bin/bridgetown test`        | Run the project's test build task         |

`deploy` and `test` are standard tasks from the `Rakefile` generated for a new Bridgetown site. If the project
customizes or removes those tasks, the corresponding aliases follow that project behavior.
