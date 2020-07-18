# Battery Plugin

This plugin adds some functions you can use to display battery information in your custom theme.

To use, add `battery` to the list of plugins in your `.zshrc` file:

`plugins=(... battery)`

Then, add the `battery_pct_prompt` function to your custom theme. For example:

```
RPROMPT='$(battery_pct_prompt) ...'
```

## Requirements

On Linux, you must have the `acpi` tool installed on your operating system.

Here's an example of how to install with apt:
```
sudo apt-get install acpi
```
