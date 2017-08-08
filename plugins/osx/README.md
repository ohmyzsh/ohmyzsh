# OSX plugin

## Description

This plugin provides a few utilities to make it more enjoyable on OSX.

To start using it, add the `osx` plugin to your plugins array in `~/.zshrc`:

```zsh
plugins=(... osx)
```
Original author: [Sorin Ionescu](https://github.com/sorin-ionescu)
## Commands
| Command         | Description                                      |
| :-------------- | :----------------------------------------------- |
| `tab`           | Open the current directory in a new tab          |
| `split_tab`     | Split the current terminal tab horizontally      |
| `vsplit_tab`    | Split the current terminal tab vertically        |
| `ofd`           | Open the current directory in a Finder window    |
| `pfd`           | Return the path of the frontmost Finder window   |
| `pfs`           | Return the current Finder selection              |
| `cdf`           | `cd` to the current Finder directory             |
| `pushdf`        | `pushd` to the current Finder directory          |
| `quick-look`    | Quick-Look a specified file                      |
| `man-preview`   | Open a specified man page in Preview app         |
| `showfiles`     | Show hidden files                                |
| `hidefiles`     | Hide the hidden files                            |
| `itunes`        | Control iTunes. User `itunes -h` for usage details |
| `spotify`       | Control Spotify and search by artist, album, track and etc.|


Note: Spotify command requires OAUTH token for searching music. It can be generated
from [Spotify Web API Console](https://developer.spotify.com/web-api/console/get-search-item/).
Do not make your Spotify OAUTH token public.

```zsh
export SPOTIFY_OAUTH_TOKEN="..."
```
