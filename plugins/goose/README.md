# Goose plugin

This plugin adds aliases for the [Goose](https://pressly.github.io/goose/)

To use it, add `goose` to the plugins array in your zshrc file:

```zsh
plugins=(... goose)
```

## Aliases

| Alias  | Command                     | Description                                                      |
| ------ | ----------------------------| -----------------------------------------------------------------|
| gmu    | `goose up`                  | Apply all available migrations                                   |
| gubo   | `goose up-by-one`           | Migrate up a single migration from the current version           |
| gmd    | `goose down`                | Roll back a single migration from the current version            |
| gmr    | `goose redo`                | Roll back the most recently applied migration, then run it again |
| gms    | `goose status`              | Print the status of all migrations:                              |
| gmcs   | `goose create migration sql`| Create a new SQL migration                                       |
| gmcg   | `goose create migration go` | Create a new Go Migration                                        |
| gmut   | `goose up-to <migration>`   | Migrate up to a specific version`                                |
| gmdt   | `goose down-to <migration>` | Roll back migrations to a specific version.                      |
| gmf    | `goose fix`                 | Apply sequential ordering to migrations                          |
