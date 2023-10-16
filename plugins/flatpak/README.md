# Flatpak Plugin

This plugin adds some aliases and functions for Flatpak package manager using the `flatpak` command. 

```zsh
plugins=(... flatpak)
```

## Aliases

| Alias    | Command                      | Description                                       |
| :------- | :--------------------------- | :------------------------------------------------ |
| flatin   | `flatpak install`            | Installs an application or runtime                |
| flatup   | `flatpak update`             | Update an installed application or runtime        |
| flatun   | `flatpak uninstall`          | Uninstall an installed application or runtime     |
| flatls   | `flatpak list`               | List installed apps and/or runtimes               |
| flatpin  | `flatpak pin`                | Pin a runtime to prevent automatic removal        |
| flatinf  | `flatpak info`               | Show info for installed app or runtime            |
| flathis  | `flatpak history`            | Show history                                      |
| flatrep  | `flatpak repair`             | Repair flatpak installation                       |
| flatcfg  | `flatpak config`             | Configure flatpak                                 |
| flatbak  | `flatpak create-usb`         | Put applications or runtimes onto removable media |
| flatmask | `flatpak mask`               | Mask out updates and automatic installation       |
| flatfind | `flatpak search`             | Search for remote apps/runtimes                   |
| flatrun  | `flatpak run`                | Run an application                                |
| flatps   | `flatpak ps`                 | Enumerate running applications                    |
| flatkill | `flatpak kill`               | Stop a running application                        |