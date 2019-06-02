# nordvpn plugin

This plugin adds completion for the [NordVPN](https://nordvpn.com/download/linux) Linux Client,
as well as aliases.

To use it, add `nordvpn` to the plugins array in your zshrc file:

```zsh
plugins=(... nordvpn)
```


## Completion

 | Command            | Completion of..                                                                                         |
 | ------------------ | ------------------------------------------------------------------------------------------------------- |
 | nordvpn            | All below commands, as well as `--help`, `-h`, `--version` and `-v`.                                    |
 | .. cities          | `--help` and `-h`                                                                                       |
 | .. connect         | Group names, Country names and City names if following a Country, `--help` and `-h`.                    |
 | .. countries       | `--help` and `-h`                                                                                       |
 | .. disconnect      | `--help` and `-h`                                                                                       |
 | .. groups          | `--help` and `-h`                                                                                       |
 | .. login           | `--username`, `-u`, `--password`, `-p`, `--help` and `-h`                                               |
 | .. logout          | `--help` and `-h`                                                                                       |
 | .. set             | `autoconnect`, `cybersec`, `dns`, `killswitch`, `notify`, `obfuscate` and `protocol`, `--help` and `-h` |
 | .. set autoconnect | `off`, `on`, `--help` and `-h`. `on` is followed by the same completion options as connect.             |
 | .. set cybersec    | `on`, `off`, `--help` and `-h`                                                                          |
 | .. set dns         | `off`, `--help` and `-h`                                                                                |
 | .. set killswitch  | `on`, `off`, `--help` and `-h`                                                                          |
 | .. set notify      | `on`, `off`, `--help` and `-h`                                                                          |
 | .. set obfuscate   | `on`, `off`, `--help` and `-h`                                                                          |
 | .. set protocol    | `TCP`, `UDP`, `--help` and `-h`                                                                         |
 | .. settings        | `--help` and `-h`                                                                                       |
 | .. status          | `--help` and `-h`                                                                                       |
 | .. whitelist       | `--help` and `-h`                                                                                       |
                         
## Aliases

 | Alias        | Command              | Description                                           |
 | ------------ | -------------------- | ----------------------------------------------------- |
 | nord         | `nordvpn`            | Alias for nordvpn                                     |
 | nordcit      | `nordvpn cities`     | Shows a list of cities where servers are available    |
 | nordc        | `nordvpn connect`    | Connects you to VPN                                   |
 | nordcout     | `nordvpn countries`  | Shows a list of countries where servers are available |
 | nordd        | `nordvpn disconnect` | Disconnects you from VPN                              |
 | nordgrp      | `nordvpn groups`     | Shows a list of available server groups               |
 | nordl        | `nordvpn login`      | Logs you in                                           |
 | nordlo       | `nordvpn logout`     | Logs you out                                          |
 | nordset      | `nordvpn set`        | Sets a configuration option                           |
 | nordsettings | `nordvpn settings`   | Shows current settings                                |
 | nordst       | `nordvpn status`     | Shows connection status                               |
 | nordwh       | `nordvpn whitelist`  | Adds or removes an option from a whitelist            |
 | nordh        | `nordvpn help`       | Shows a list of commands or help for one command      |