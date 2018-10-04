# Postgres plugin

This plugin adds some aliases for useful Postgres commands.

:warning: this plugin works exclusively with Postgres installed via Homebrew on OSX
because Postgres paths are hardcoded to `/usr/local/var/postgres`.

To use it, add `postgres` to the plugins array in your zshrc file:

```zsh
plugins=(... postgres)
```

## Aliases

| Alias       | Command                                                                         | Description                                                 |
|-------------|---------------------------------------------------------------------------------|-------------------------------------------------------------|
| startpost   | `pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start` | Start postgres server                                       |
| stoppost    | `pg_ctl -D /usr/local/var/postgres stop -s -m fast`                             | Stop postgres server                                        |
| restartpost | `stoppost && sleep 1 && startpost`                                              | Restart (calls stop, then start)                            |
| reloadpost  | `pg_ctl reload -D /usr/local/var/postgres -s`                                   | Reload postgres configuration (some setting require restart)|
| statuspost  | `pg_ctl status -D /usr/local/var/postgres -s`                                   | Check startus of postgres server (running, stopped)         |
