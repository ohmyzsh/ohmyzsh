# dbt plugin

The `dbt plugin` adds several aliases for useful [dbt](https://docs.getdbt.com/) commands and
[aliases](#aliases).

To use it, add `dbt` to the plugins array of your zshrc file:

```zsh
plugins=(... dbt)
```

## Aliases

| Alias  | Command                                          | Description                                          |
| ------ | ------------------------------------------------ | ---------------------------------------------------- |
| dbtlm  | `dbt ls -s state:modified`                       | List modified models only                            |
| dbtrm  | `dbt run -s state:modified`                      | Run modified models only                             |
| dbttm  | `dbt test -m state:modified`                     | Test modified models only                            |
| dbtrtm | `dbtrm && dbttm`                                 | Run and test modified models only                    |
| dbtrs  | `dbt clean; dbt deps; dbt seed`                  | Re-seed data                                         |
| dbtfrt | `dbtrs; dbt run --full-refresh; dbt test`        | Perform a full fresh run with tests                  |
| dbtcds | `dbt docs generate; dbt docs serve`              | Generate docs without compiling                      |
| dbtds  | `dbt docs generate --no-compile; dbt docs serve` | Generate and serve docs skipping doc. re-compilation |

## Maintainer

- [msempere](https://github.com/msempere)
