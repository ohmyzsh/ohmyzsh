# Battery Plugin

This plugin adds some functions you can use to display battery information in your custom theme.

To install, add `batery` to the list of plugins in your `.zshrc` file:

`plugins=(... battery)`

Then, add the `battery_pct_prompt` function to your custom theme:

`PROMPT='$(battery_pct_prompt)'`
