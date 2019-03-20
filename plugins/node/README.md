# node plugin

To use it, add `node` to the plugins array of your zshrc file:
```zsh
plugins=(... node)
```

This plugin adds `node-docs` function that open specific section in [Node.js](https://nodejs.org) documentation (depending on the installed version).
For example:

```zsh
# Opens https://nodejs.org/docs/latest-v10.x/api/fs.html
$ node-docs fs
# Opens https://nodejs.org/docs/latest-v10.x/api/path.html
$ node-docs path 
```
