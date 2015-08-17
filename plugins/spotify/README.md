# Control Spotify at OS X Terminal

An AppleScript for controlling Spotify through a terminal:

```
The scenario for which it was originally designed is controlling Spotify,
which is playing on a Mac, via ssh, while working on a Linux machine
on the other side of the room.
```

Currently supported functions are: play/pause, next/previous
track, jumping in time, toggling shuffle/repeat and changing volume.
This pretty much covers everything the AppleScript hooks of Spotify
allow.

### Tested Platforms (Spotify 1.0.4.90)
* OS X Yosemite (10.10)
* OS X Mavericks (10.9)
* OS X Mountain Lion (10.8)
* OS X Lion (10.7)

## Installation

The simplest way to install the script is to `clone` the repository,
`cd` into repository's directory, and run this command below
to make a symbolic link into `/usr/local/bin/`:

```bash
ln -s $(pwd)/spotify /usr/local/bin/spotify
```


## Usage

* To start Spotify playback, type `spotify start` or `spotify play`.
If you do this locally and Spotify is not running, it will start.
Remotely, Spotify will not start properly. Optionally, pass a Spotify URI as a second argument.
* To pause Spotify playback, type `spotify stop` or `spotify pause`.
* To toggle playback, type `spotify play/pause`.
* To go to the next track, type `spotify next`.
* To go to the previous track, type `spotify previous` or `spotify
prev`.
* To print information about the currently playing track,
type `spotify info`
* To jump to a particular time in the track, type `spotify jump N`,
where N is the track position in seconds.
* To fast forward, type `spotify forward N` where N is the number of
seconds to jump ahead.
* To rewind, type `spotify rewind N` where N is the number of
seconds to jump backwards.
* To change volume, type `spotify volume N` where N is a number between
0 and 100.
* To toggle shuffle, type `spotify shuffle`.
* To toggle repeat, type `spotify repeat`.
* To show a list of these commands, just type `spotify`.

### Over SSH

To enable the SSH server on OS X, go to Sharing in the System Preferences
and enable Remote Login. The Sharing screen will also then tell you the
command to use to connect to your Mac in the local network.

## License

You may use, adapt, modify, and etc. Any way you want.
