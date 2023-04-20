# dbt plugin

## Introduction

The `dbt plugin` adds several aliases for useful [dbt](https://docs.getdbt.com/) commands and [aliases](#aliases).

To use it, add `dbt` to the plugins array of your zshrc file:

```
plugins=(... dbt)
```

## Aliases

| Alias       | Command                          | Description                                                                   |
|-------------|----------------------------------|-------------------------------------------------------------------------------|
| dbtb        | `dbt build`                      | Install packages from the repositories                                        |
| dbtcl       | `dbt clean`                      | Clean the project, deletes all folders specified in the clean-targets list    |
| dbtco       | `dbt compile`                    | Compile the project                                                           |
| dbtdg       | `dbt debug`                      | Debug the project                                                             |
| dbtdgc      | `dbt debug --config-dir`         | Show the configured location for the profiles.yml file                        |
| dbtdog      | `dbt docs generate`              | Generate docs                                                                 |
| dbtdogn     | `dbt docs generate --no-compile` | Generate docs without compiling                                               |
| dbtdos      | `dbt docs serve`                 | Serve docs                                                                    |
| dbtds       | `dbt deps`                       | Pulls the most recent version of the dependencies listed in packages.yml      |
| dbti        | `dbt init`                       | Initialize a new dbt project                                                  |
| dbtl        | `dbt ls`                         | List available models                                                         |
| dbtpa       | `dbt parse`                      | Parse the project                                                             |
| dbtr        | `dbt run`                        | Run a model                                                                   |
| dbtrf       | `dbt run --full-refresh`         | Run a model with a full refresh                                               |
| dbtro       | `dbt run-operation`              | Invoke a macro                                                                |
| dbts        | `dbt seed`                       | Load csv files located in the seed-paths directory of the dbt project         |
| dbtsn       | `dbt snapshot`                   | Executes the Snapshots defined in the project                                 |
| dbtsof      | `dbt source freshness`           | Query all of defined source tables, determining their "freshness"             |
| dbtsw       | `dbt show`                       | Generates post-transformation preview from a source model, test, or analysis  |
| dbtt        | `dbt test`                       | Runs tests defined on models, sources, snapshots, and seeds                   |
| dbtv        | `dbt --verion`                   | Show the version on dbt installed in this host                                |

## Maintainer

### [msempere](https://github.com/msempere) 
