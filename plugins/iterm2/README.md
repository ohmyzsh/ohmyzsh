# iTerm2 plugin

This plugin adds a few functions that are useful when using [iTerm2](https://www.iterm2.com/).

To use it, add _iterm2_ to the plugins array of your zshrc file:
```
plugins=(... iterm2)
```

## Plugin commands

* `_iterm2_command <iterm2-command>`
  executes an arbitrary iTerm2 command via an escape code sequence.
  See https://iterm2.com/documentation-escape-codes.html for all supported commands.

* `iterm2_profile <profile-name>`
  changes the current terminal window's profile (colors, fonts, settings, etc).
  `profile-name` is the name of another iTerm2 profile. The profile name can contain spaces.

* `iterm2_tab_color <red> <green> <blue>`
  changes the color of iTerm2's currently active tab.
  `red`/`green`/`blue` are on the range 0-255.

* `iterm2_tab_color_reset`
  resets the color of iTerm2's current tab back to default.

## Contributors

- [Aviv Rosenberg](https://github.com/avivrosenberg)
