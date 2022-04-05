# Grails plugin

This plugin adds completion for the [Grails 2 CLI](https://grails.github.io/grails2-doc/2.5.x/guide/commandLine.html)

To use it, add `grails` to the plugins array in your zshrc file:

```zsh
plugins=(... grails)
```

It looks for scripts in the following paths:

- `$GRAILS_HOME/scripts`
- `~/.grails/scripts`
- `./scripts`
- `./plugins/*/scripts`
