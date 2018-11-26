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

## Grails Commands
- `add-proxy`
- `alias`
- `bootstrap`
- `bug-report`
- `clean`
- `clean-all`
- `clear-proxy`
- `compile`
- `console`
- `create-app`
- `create-controller`
- `create-domain-class`
- `create-filters`
- `create-integration-test`
- `create-multi-project-build`
- `create-plugin`
- `create-pom`
- `create-script`
- `create-service`
- `create-tag-lib`
- `create-unit-test`
- `dependency-report`
- `doc`
- `help`
- `init`
- `install-app-templates`
- `install-dependency`
- `install-plugin`
- `install-templates`
- `integrate-with`
- `interactive`
- `list-plugin-updates`
- `list-plugins`
- `migrate-docs`
- `package`
- `package-plugin`
- `plugin-info`
- `refresh-dependencies`
- `remove-proxy`
- `run-app`
- `run-script`
- `run-war`
- `set-grails-version`
- `set-proxy`
- `set-version`
- `shell`
- `stats`
- `stop-app`
- `test-app`
- `uninstall-plugin`
- `url-mappings-report`
- `war`
- `wrapper`
