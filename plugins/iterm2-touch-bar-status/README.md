# iTerm2 Touch Bar Status Plugin

This plugin allows you to set the text of the Status button on the MacBook Pro Touch Bar when using [iTerm2](https://www.iterm2.com/).

To setup, follow the instructions:

1. Install iTerm2 Shell Integration and Utilities by going to `iTerm2 -> Install Shell Integration` and selecting `Install Shell Integration & Utilities`. The default installation location is `~/.iterm2` but you can override this by setting `$ITERM2_DIR` in your `.zshrc`.

2. Add the Status button to the Touch Bar by going to `View -> Customize Touch Bar` and draging the "Status/Your Message Here" button to the Touch Bar.

3. Enable this plugin in your `.zshrc` file:
```
plugins=(... iterms-touch-bar-status)
```

4. While the text defaults to your current working directory, you can set it to anything you like by setting `$ITERM2_TOUCH_BAR_STATUS` in your `.zshrc` (or anywhere else actually).

## Contributors

- [Jeff Erickson](https://github.com/jefferickson)
