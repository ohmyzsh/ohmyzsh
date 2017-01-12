This plugin was created because the aliases in the debian plugin are inconsistent and hard to remember. Also this apt-priority detection that switched between apt-get and aptitude was dropped to keep it simpler. This plugin uses apt-get for everything but a few things that are only possible with aptitude I guess. Ubuntu does not have aptitude installed by default.

# Apt-Get Aliases

## Single Command Aliases

| Alias  | Command                          |
| :----- | :------------------------------- |
| `acps` | `apt-cache policy`               |
| `acs`  | `apt-cache search`               |
| `afs`  | `apt-file search --regexp`       |
| `afu`  | `sudo apt-file update`           |
| `ag`   | `sudo apt-get`                   |
| `aga`  | `sudo apt-get autoclean`         |
| `agar` | `sudo apt-get autoremove`        |
| `agb`  | `sudo apt-get build-dep`         |
| `agc`  | `sudo apt-get clean`             |
| `agd`  | `sudo apt-get dselect-upgrade`   |
| `agdu` | `sudo apt-get dist-upgrade`      |
| `agi`  | `sudo apt-get install`           |
| `agp`  | `sudo apt-get purge`             |
| `agr`  | `sudo apt-get remove`            |
| `agu`  | `sudo apt-get update`            |
| `agug` | `sudo apt-get ugrade`            |
| `ags`  | `apt-get source`                 |
| `ppap` | `sudo ppa-purge`                 |

## Multi-Command Aliases

| Alias                | Command                                        |
| :------------------- | :--------------------------------------------- |
| `agud`               | `agu && agdu`                                  |
| `aguu`               | `agu && agu`                                   |
| `safe-upgrade-clean` | `agu && agdu && agar && aga`                   |

## Special Commands

This commands are a little bit more complicated, so the actual commands will be ommited from this README. Check the actual source in the `ubuntu.plugin.zsh` file.


| Alias  | Description                         |
| :----- | :------------------------------- |
| `kclean` | Removes ALL kernel images and headers EXCEPT the one in use. |
| `allpkgs` | Prints all installed packages in your system. |
| `mydeb` | Creates a basic `.deb` package. |
| `aar` | Adds a PPA repository and installs a package. Usage: `aar ppa:xxxxxx/xxxxxx [packagename]` |
| `apt-history` | Prints apt history. Usage: <code>apt-history  install&#124;upgrade&#124;remove&#124;rollback&#124;list</code> |
| `kerndeb` | Shortcut for kernel-package building. |
| `apt-list-packages` | Lists installed packages sorted by size. |

# Spotify Control Commands

A variety of commands to control your Spotify client from the commodity of your console using dark magic*.

\* May contain `dbus` and `curl` dark magic.

## Requirements

You still need to have the Spotify client installed and open to make this commands work properly.

You can download the client from here: https://www.spotify.com/download/

## Usage

`spotify-ctl [command]`

| Commands     | Description                                                |
| :----------- | :--------------------------------------------------------- |
| `play`       | Play Spotify                                               |
| `pause`      | Pause Spotify                                              |
| `playpause`  | Toggles betwen play/pause                                  |
| `next`       | Go to next track                                           |
| `prev`       | Go to previous track                                       |
| `current`    | Displays the current track metadata                        |
| `metadata`   | Displays the current track raw metadata                    |
| `eval`       | Returns the current track metadata as a shell variables <code>SPOTIFY_(title&#124;album&#124;artist&#124;trackid&#124;trackNumber)</code> |
| `art`        | Prints the URL to the current track's album artwork        |
| `url`        | Prints the URL for the current track                       |
| `http`       | Open the current track in a web browser                    |
| `open <uri>` | Opens a Spotify URI in the client"                         |
| `search <q>` | Start playing the best search result for the given query   |
| `help`       | Displays the help text                                     |
| `<q>`        | `spotify-ctl foo` will search for `foo`                    |
