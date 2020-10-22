# node plugin

This plugin provides many a aliases and a few `node-docs` functions.

## Aliases

| Alias                | Command                                                                        |
|:---------------------|:-------------------------------------------------------------------------------|
| nd                   | node                                                                           |
| ndc                  | node --check                                                                   |
| nde                  | node --eval "script"                                                           |
| ndh                  | node --help                                                                    |
| ndi                  | git --interactive                                                              |
| ndr                  | git --require module                                                           |
|----------------------|--------------------------------------------------------------------------------|
| ndnd                 | node --no-depreciation                                                         |
| ndnw                 | node --no-warnings                                                             |
| ndtw                 | node --trace-warnings                                                          |
| ndv8                 | node --V8-options                                                              |
|----------------------|--------------------------------------------------------------------------------|

## Functions

```zsh
# Opens https://nodejs.org/docs/latest-v10.x/api/fs.html
$ node-docs fs
# Opens https://nodejs.org/docs/latest-v10.x/api/path.html
$ node-docs path
```

This plugin adds `node-docs` function that opens specific section in [Node.js](https://nodejs.org)
documentation (depending on the installed version).

## Add plugin
To use it, add `node` to the plugins array of your zshrc file:

```zsh
plugins=(... node)
```