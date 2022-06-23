# RedwoodJS

This plugin adds [RedwoodJS](https://redwoodjs.com/docs/cli-commands) command line interface aliases.

To use it, add `redwood` to the plugins array in your zshrc file:

```zsh
plugins=(... redwood)
```

## Aliases

| Alias       | Command                             | Description                                                        |
| ----------- | ----------------------------------- | ------------------------------------------------------------------ |
| ycr         | yarn create redwood-app             | Creates a redwood project                                          |
| yrb         | yarn redwood dataMigrate            | Builds for production                                              |
| yrdb        | yarn redwood dataMigrate            | Data migration tools                                               |
| yrdev       | yarn redwood dev                    | Starts development servers for api and web                         |
| yrgencell   | yarn redwood generate cell          | Generate a cell                                                    |
| yrdelcell   | yarn redwood destroy cell           | Destroy a cell                                                     |
| yrgencomp   | yarn redwood generate component     | Generate a component                                               |
| yrdelcomp   | yarn redwood destroy component      | Destroy a component                                                |
| yrgenmirate | yarn redwood generate dataMigration | Generates a data migration script                                  |
| yrgendir    | yarn redwood generate directive     | Generates a directive                                              |
| yrdeldir    | yarn redwood destroy directive      | Destroy a directive                                                |
| yrgenfunc   | yarn redwood generate function      | Generate a function                                                |
| yrdelfunc   | yarn redwood destroy function       | Destroy a function                                                 |
| yrgenlay    | yarn redwood generate layout        | Generate a layout component                                        |
| yrdellay    | yarn redwood destroy layout         | Destroy a layout component                                         |
| yrgenmod    | yarn redwood generate model         | Generate a RedwoodRecord model                                     |
| yrdelmod    | yarn redwood destroy model          | Destroy a RedwoodRecord model                                      |
| yrgenp      | yarn redwood generate page          | Generates a page component and updates the routes                  |
| yrdelp      | yarn redwood destroy page           | Destroys a page component                                          |
| yrdensc     | yarn redwood generate scaffold      | Generate Pages, SDL, and Serviecs based on a given DB schema model |
| yrdelsc     | yarn redwood destroy scaffold       | Destroys scaffold                                                  |
| yrgengql    | yarn redwood generate sdl           | Generate GraphQL schema and service object                         |
| yrgenql     | yarn redwood destroy sdl            | Destroys GraphQL schema and service object                         |
| yrsecret    | yarn redwood generate secret        | Generates a secret                                                 |
| yrgenser    | yarn redwood generate service       | Generate a service component                                       |
| yrdelser    | yarn redwood destroy service        | Destroy a service component                                        |
| yrgentype   | yarn redwood generate types         | Generates supplemntary code (project types)                        |
| yrgenscript | yarn redwood generate script        | Generates script                                                   |
| yrinfo      | yarn redwood info                   | Prints system enviroment information                               |
| yrlint      | yarn redwood lint                   | Lint your files                                                    |
| yrpr        | yarn redwood prisma                 | Run Prisma CLI                                                     |

## Requirements

More info on usage: https://redwoodjs.com/docs/cli-commands
