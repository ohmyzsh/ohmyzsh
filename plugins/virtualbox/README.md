# VirtualBox plugin

The `virtualbox` plugin provides many useful aliases for VirtualBox.

To use it, add `virtualbox` to the plugins array of your `.zshrc` file:

```zsh
plugins=(... virtualbox)
```

## Aliases

| Alias                  | Command                               | Description                                                        |
|:-----------------------|:--------------------------------------|:-------------------------------------------------------------------|
| `vbox-start`           | `VBoxManage startvm`                  | Start a virtual machine                                            |
| `vbox-start-headless`  | `VBoxManage startvm --type=headless`  | Start a virtual machine (headless mode)                            |
| `vbox-clone`           | `VBoxManage clonevm --register`       | Clone and register a virtual machine                               |
| `vbox-create`          | `VBoxManage createvm --register`      | Create and register a new virtual machine                          |
| `vbox-create-medium`   | `VBoxManage createmedium`             | Create a new medium                                                |
| `vbox-delete`          | `VBoxManage unregistervm --delete`    | Unregister and delete a virtual machine                            |
| `vbox-control`         | `VBoxManage controlvm`                | Control a virtual machine                                          |
| `vbox-info`            | `VBoxManage showvminfo`               | Show information about a virtual machine                           |
| `vbox-list`            | `VBoxManage list`                     | List system information and configuration                          |
| `vbox-poweroff`        | `VBoxManage controlvm "$1" poweroff`  | Forcibly power off a virtual machine                               |
| `vbox-shutdown`        | `VBoxManage controlvm "$1" shutdown`  | Gracefully shutdown a virtual machine                              |
| `vbox-stop`            | `aliased to vbox-shutdown`            | -                                                                  |
| `vbox-pause`           | `VBoxManage controlvm "$1" pause`     | Pause execution of a virtual machine                               |
| `vbox-resume`          | `VBoxManage controlvm "$1" resume`    | Resume execution of a virtual machine                              |
| `vbox-save`            | `VBoxManage controlvm "$1" savestate` | Save current state of a virtual machine                            |
| `vbox-discard`         | `VBoxManage discardstate`             | Discard saved state of a virtual machine                           |
| `vbox-reboot`          | `VBoxManage controlvm "$1" reboot`    | Reboot a virtual machine                                           |
| `vbox-reset`           | `VBoxManage controlvm "$1" reset`     | Reset a virtual machine                                            |

The prefix for the aliases can be customised by setting `ZSH_PLUGIN_VIRTUALBOX_ALIAS_PREFIX` (default: `vbox`).

## Status prompt

Add `$(virtualbox_prompt_info [vm_name] ...)` to your prompt to show the status
of all specified virtual machines.

The plugin will add the following to your prompt for each `$vm_name`.

```text
<prefix><vm_name>:<running|notrunning><suffix>
```

You can control these parts with the following variables:

- `<prefix>`: Set `$ZSH_THEME_VIRTUALBOX_PROMPT_PREFIX`.

- `<suffix>`: Set `$ZSH_THEME_VIRTUALBOX_PROMPT_SUFFIX`.

- `<vm_name>`: name passed as parameter to the function. If you want it to be in ALL CAPS,
  you can set the variable `$ZSH_THEME_VIRTUALBOX_PROMPT_CAPS` to a non-empty string.

- `<running>`: shown if the virtual machine is running.
  Set `$ZSH_THEME_VIRTUALBOX_PROMPT_RUNNING`.

- `<notrunning>`: shown if the virtual machine is *not* running.
  Set `$ZSH_THEME_VIRTUALBOX_PROMPT_NOTRUNNING`.

You can set `ZSH_THEME_VIRTUALBOX_PROMPT_COUNT` to a non-empty string to show a
count of running virtual machines / total.

For example, if your prompt contains `PROMPT='$(virtualbox_prompt_info "Arch Linux" "Debian")'`
and you set the following variables:

```sh
ZSH_THEME_VIRTUALBOX_PROMPT_COUNT="true"
ZSH_THEME_VIRTUALBOX_PROMPT_PREFIX="["
ZSH_THEME_VIRTUALBOX_PROMPT_SUFFIX="]"
ZSH_THEME_VIRTUALBOX_PROMPT_RUNNING="+"
ZSH_THEME_VIRTUALBOX_PROMPT_NOTRUNNING="X"
ZSH_THEME_VIRTUALBOX_PROMPT_CAPS="true"
```

If `Arch Linux` is running, and `Debian` is not, then your prompt will look like this:

```text
[1 / 2][ARCH LINUX: +][DEBIAN: X]
```
