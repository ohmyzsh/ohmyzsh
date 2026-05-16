# Nanoc plugin

This plugin adds some aliases and autocompletion for common [Nanoc](https://nanoc.ws) commands.

To use it, add `nanoc` to the plugins array in your zshrc file:

```zsh
plugins=(... nanoc)
```

## Aliases

| Alias | Command               | Description                                                                       |
|-------|-----------------------|-----------------------------------------------------------------------------------|
| n     | `nanoc`               | Main Nanoc command                                                                |
| nco   | `nanoc compile`       | Compile all items of the current site                                             |
| ncs   | `nanoc create-site`   | Create a new site at the given path. The site will use the filesystem data source |
| nd    | `nanoc deploy`        | Deploy the compiled site to the destination (specified with `--target`)           |
| np    | `nanoc prune`         | Remove files not managed by Nanoc from the output directory                       |
| nv    | `nanoc view`          | Start the static web server (on port 3000 and all IP addresses, unless specified) |
