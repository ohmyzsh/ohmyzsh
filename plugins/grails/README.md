# Grails plugin

Adds tab-completion of Grails script names to the command line use of grails.
Looks for scripts in the following paths:

- `$GRAILS_HOME/scripts`
- `~/.grails/scripts`
- `./scripts`
- `./plugins/*/scripts`

To use it, add `grails` to the plugins array in your zshrc file:

```zsh
plugins=(... grails)
```
