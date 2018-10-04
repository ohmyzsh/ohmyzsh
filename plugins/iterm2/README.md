# iTerm2 plugin

**This plugin is only relevant if the terminal is iTerm2 on OSX**

## Plugin commands

* ```_iterm2_command <iterm2-command>```  
executes an arbitrary iTerm2 command via an escape code sequce. 
See https://iterm2.com/documentation-escape-codes.html for all supported commands.

* ```iterm2_profile```  
changes the current terminal window's profile (colors, fonts, settings, etc).  
Usage: ```iterm2_profile <profile-name>``` where profile-name is the name of another iTerm2 profile. The profile name can contain spaces.

* ```iterm2_tab_color```  
changes the color of iTerm2's currently active tab.  
Usage: ```iterm2_tab_color <red> <green> <blue>``` where red/green/blue are on the range 0-255.

* ```iterm2_tab_color_reset```  
resets the color of iTerm2's current tab back to default.
