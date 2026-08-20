## Description

This plugin makes `zypper` usage easier by adding aliases for the most
common commands.

`zypper` is the default package manager for SUSE distributions.

## Aliases

| Alias | Command                 | Description                    |
|-------|-------------------------|--------------------------------|
| zppls | `zypper ls`             | List repositories              |
| zppll | `zypper ll`             | List locked packages           |
| zpps  | `zypper search`         | Search package                 |
| **Use `sudo`**                                                   |
| zppu  | `sudo zypper up`        | Update installed package(s)    |
| zppd  | `sudo zypper dup`       | Perform a distribution upgrade |
| zppi  | `sudo zypper install`   | Install package                |
| zppr  | `sudo zypper remove`    | Remove package                 |
| zppal | `sudo zypper al`        | Add package lock               |
| zpprl | `sudo zypper rl`        | Remove package lock            |
