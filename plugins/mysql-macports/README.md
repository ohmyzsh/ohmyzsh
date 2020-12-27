# MySQL-Macports plugin

This plugin adds aliases for some of the commonly used [MySQL](https://www.mysql.com/) commands when installed using [MacPorts](https://www.macports.org/) on macOS.

To use it, add `mysql-macports` to the plugins array in your zshrc file:

```zsh
plugins=(... mysql-macports)
```

For instructions on how to install MySQL using MacPorts, read the [MacPorts wiki](https://trac.macports.org/wiki/howto/MySQL/).

## Aliases

| Alias        | Command                              | Description                                |
| ------------ | ------------------------------------ | ------------------------------------------ |
| mysqlstart   | `sudo /path/to/mysql.server start`   | Start the MySQL server.                    |
| mysqlstop    | `sudo /path/to/mysql.server stop`    | Stop the MySQL server.                     |
| mysqlrestart | `sudo /path/to/mysql.server restart` | Restart the MySQL server.                  |
| mysqlstatus  | `mysqladmin5 -u root -p ping`        | Check whether the MySQL server is running. |
