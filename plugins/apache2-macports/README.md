<<<<<<< HEAD
## APACHE2 MACPORTS PLUGIN


---

### FEATURES

| Alias          | Function                                                                       | Description           |
|:--------------:|:-------------------------------------------------------------------------------|----------------------:|
| apache2restart | sudo /opt/local/etc/LaunchDaemons/org.macports.apache2/apache2.wrapper restart | Restart apache daemon |
| apache2start   | sudo /opt/local/etc/LaunchDaemons/org.macports.apache2/apache2.wrapper start   | Start apache daemon   |
| apache2stop    | sudo /opt/local/etc/LaunchDaemons/org.macports.apache2/apache2.wrapper stop    | Stop apache daemon    |

---

### CONTRIBUTORS
 - Alexander Rinass (alex@rinass.net)

---
=======
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
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
