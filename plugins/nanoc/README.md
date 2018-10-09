# Nanoc plugin

This plugin adds some aliases and autocompletion for common [Nanoc](https://nanoc.ws) commands.

To use it, add `nanoc` to the plugins array in your zshrc file:

```zsh
plugins=(... nanoc)
```

## Aliases

| Alias | Command               | Description                                        |
|-------|-----------------------|----------------------------------------------------|
| n     | `nanoc`               | Main Nanoc command                                 |
| na    | `nanoc autocompile`   | The autocompile command has been deprecated since Nanoc 3.6. Use [guard-nanoc](https://github.com/nanoc/nanoc/tree/master/guard-nanoc) instead. |
| nco   | `nanoc compile`       | Compile all items of the current site. |
| nci   | `nanoc create_item`   | Command was deprecated in Nanoc v.3 and completely removed in v.4 |
| ncl   | `nanoc create_layout` | Command was deprecated in Nanoc v.3 and completely removed in v.4 |
| ncs   | `nanoc create_site`   | Create a new site at the given path. The site will use the filesystem data source. |
| nd    | `nanoc deploy`        | Deploys the compiled site. The compiled site contents in the output directory will be uploaded to the destination, which is specified using the --target option. |
| nv    | `nanoc view`          | Start the static web server. Unless specified, the web server will run on port 3000 and listen on all IP addresses. |
| nw    | `nanoc watch`         | The watch command has been deprecated since Nanoc 3.6. Use [guard-nanoc](https://github.com/nanoc/nanoc/tree/master/guard-nanoc) instead. |