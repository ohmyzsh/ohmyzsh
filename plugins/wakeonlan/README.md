# wakeonlan

This plugin provides a wrapper around the "wakeonlan" tool available from most
distributions' package repositories, or from [the following website](https://github.com/jpoliv/wakeonlan).

To use it, add `wakeonlan` to the plugins array in your zshrc file:

```zsh
plugins=(... wakeonlan)
```

## Usage

In order to use this wrapper, create the `~/.wakeonlan` directory, and place in
that directory one file for each device you would like to be able to wake. Give
the file a name that describes the device, such as its hostname. Each file
should contain a line with the mac address of the target device and the network
broadcast address.

For instance, there might be a file ~/.wakeonlan/leto with the following
contents:

```
00:11:22:33:44:55:66 192.168.0.255
```

To wake that device, use the following command:

```console
$ wake leto
```

The available device names will be autocompleted, so:

```console
$ wake <tab>
```

...will suggest "leto", along with any other configuration files that were
placed in the ~/.wakeonlan directory.

For more information regarding the configuration file format, check the
wakeonlan man page.
