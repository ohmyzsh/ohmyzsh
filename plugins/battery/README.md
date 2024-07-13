# Battery Plugin

This plugin adds some functions you can use to display battery information in your custom theme.

To use, add `battery` to the list of plugins in your `.zshrc` file:

`plugins=(... battery)`

Then, add the `battery_pct_prompt` function to your custom theme. For example:

```zsh
RPROMPT='$(battery_pct_prompt) ...'
```

Also, you set the `BATTERY_CHARGING` variable to your favor.
For example:

```zsh
BATTERY_CHARGING="⚡️"
```

## Requirements

- On Linux, you must have the `acpi` or `acpitool` commands installed on your operating system.
  On Debian/Ubuntu, you can do that with `sudo apt install acpi` or `sudo apt install acpitool`.

- On Android (via [Termux](https://play.google.com/store/apps/details?id=com.termux)), you must have:

  1. The `Termux:API` addon app installed:
     [Google Play](https://play.google.com/store/apps/details?id=com.termux.api) | [F-Droid](https://f-droid.org/packages/com.termux.api/)

  2. The `termux-api` package installed within termux:

     ```sh
     pkg install termux-api
     ```
