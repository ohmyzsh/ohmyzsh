# FirewallD Plugin

This plugin adds some aliases and functions for FirewallD using the `firewalld-cmd` command. To use it, add firewalld to your plugins array.

```
plugins=(... firewalld)
```

## Aliases

| Alias | Command                              | Description                  |
| :---- | :----------------------------------- | :--------------------------- |
| fw    | `firewall-cmd`                        | Shorthand                    |
| fwr   | `firewall-cmd --reload`               | Reload current configuration |
| fwp   | `firewall-cmd --permanent`            | Create permanent rule        |
| fwrp  | `firewall-cmd --runtime-to-permanent` | Save current configuration   |

## Functions

| Function | Description                                                |
| :------- | :--------------------------------------------------------- |
| fwl      | Lists configuration from all active zones and direct rules |
