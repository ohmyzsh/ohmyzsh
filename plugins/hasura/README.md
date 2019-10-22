# Hasura

this plugins provides aliases for frequent hasura-client commands.

To use it, add hasura to the plugins array of your zshrc file:
```
plugins=(... hasura)
```

## Aliases

| Alias     | Command                  | Description                                                      |
|-----------|--------------------------|------------------------------------------------------------------|
| h         | `hasura`                 | hasura main command                                              | 
| hma       | `hasura migrate apply`   | Apply hasura migrations                                          |
| hms       | `hasura migrate status`  | Check migration status of hasura                                 |
| hc        | `hasura console`         | Start hasura UI                                                  |
