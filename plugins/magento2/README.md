# Magento2 plugin

This plugin adds completion and aliases for the `magento` command. More information at https://github.com/denisristic/oh-my-zsh.

Enable magento2 plugin in your zshrc file:
```
plugins=(... magento2)
```

## Aliases

| Alias       | Command                                   | Description                                                               |
|-------------|-------------------------------------------|---------------------------------------------------------------------------|
| `m2`        | `magento`                             | Magento command                                                               |
| `m2clean`   | `magento cache:clean`                 | Cleans cache type(s)                                                          |
| `m2reindex` | `magento indexer:reindex`             | Reindexes Data                                                                |
| `m2compile` | `magento setup:di:compile`            | Generates DI configuration and all missing classes that can be auto-generated |
| `m2upgrade` | `magento setup:upgrade`               | Upgrades the Magento application, DB data, and schema                         |
| `m2sdeploy` | `magento setup:static-content:deploy` | Deploys static view files                                                     |