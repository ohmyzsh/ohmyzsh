# apache2-macports plugin

Enables aliases to control a local Apache2 installed via [MacPorts](https://www.macports.org/).

To use it, add `apache2-macports` to the plugins array in your zshrc file:

```zsh
plugins=(... apache2-macports)
```

## Aliases

| Alias          | Function                                | Description           |
|----------------|-----------------------------------------|-----------------------|
| apache2restart | `sudo /path/to/apache2.wrapper restart` | Restart apache daemon |
| apache2start   | `sudo /path/to/apache2.wrapper start`   | Start apache daemon   |
| apache2stop    | `sudo /path/to/apache2.wrapper stop`    | Stop apache daemon    |

## Contributors

- Alexander Rinass (alex@rinass.net)
