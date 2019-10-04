# MySQL-Macports plugin

This plugin adds aliases for some of the commonly used [MySQL](https://www.mysql.com/) commands when installed using [MacPorts](https://www.macports.org/) on the MacOS. This facilitates easy use of MySQL-Server on MacOS machines using oh-my-zsh and eliminates the need to remember the complicated commands or paths for the same. For instructions to install MySQL using MacPorts, read the [MacPorts wiki](https://trac.macports.org/wiki/howto/MySQL/).

To use it, add `mysql-macports` to the plugins array in your zshrc file:

```zsh
plugins=(... mysql-macports)
```

## Aliases

| Alias        | Command                                                   | Description                                                         |
| ------------ | --------------------------------------------------------- | ------------------------------------------------------------------- |
| mysqlstart   | `sudo /opt/local/share/mysql5/mysql/mysql.server start`   | Start the MySQL server.                                             |
| mysqlstop    | `sudo /opt/local/share/mysql5/mysql/mysql.server stop`    | Stop the MySQL server.                                              |
| mysqlrestart | `sudo /opt/local/share/mysql5/mysql/mysql.server restart` | Stop the MySQL server.                                              |
| mysqlstatus  | `mysqladmin5 -u root -p ping`                             | Ping the MySQLAdmin to know the current status of the MySQL server. |
