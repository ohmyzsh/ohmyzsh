# Bower plugin

This plugin adds completion for [Bower](https://bower.io/) and a few useful aliases for common Bower commands.

To use it, add `bower` to the plugins array in your zshrc file:

```
plugins=(... bower)
```

## Aliases

| Alias | Command         | Description                                            |
|-------|-----------------|--------------------------------------------------------|
| bi    | `bower install` | Installs the project dependencies listed in bower.json |
| bl    | `bower list`    | List local packages and possible updates               |
| bs    | `bower search`  | Finds all packages or a specific package.              |

