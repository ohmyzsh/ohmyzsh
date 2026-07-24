# carthage plugin

The carthage plugin provides all [aliases](#aliases) .

To use it, add `carthage` to the plugins array in your zshrc file:

```zsh
plugins=(... carthage)
```

## Aliases

| Alias                | Command                                                                                                                          |
|:---------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| c                    | carthage                                                                                                                         |
| ca                   | carthage archive                                                                                                                 |
| cb                   | carthage build                                                                                                                   |
| cbs                  | carthage bootstrap                                                                                                               |
| cck                  | carthage checkout                                                                                                                |
| ccf                  | carthage copy-frameworks                                                                                                         |
| cf                   | carthage fetch                                                                                                                   |
| ch                   | carthage help                                                                                                                    |
| cl                   | cat Cartfile                                                                                                                     |
| co                   | carthage outdated                                                                                                                |
| cu                   | carthage update                                                                                                                  |
| cv                   | carthage  validate 																											  |
| cver                 | carthage version                                                                                                                 |