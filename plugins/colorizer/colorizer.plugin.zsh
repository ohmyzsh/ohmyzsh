# This plugin is in the making, no need to start it.
# The point of this plugin is so we can use our own $fg replacements that respect customization!
#
# A method to get/collect escape codes from #RRGGBB hex needs to be added but only used to gather the escape codes. ( should be two-way. )
__colors=(cyan white yellow magenta black blue red default grey green)
_ecolors=("\e[36m" "\e[37m" "\e[33m" "\e[35m" "\e[30m" "\e[34m" "\e[31m" "\e[39m" "\e[30m" "\e[32m")
# This is just an easy way to show all the colors.
echo ${^_ecolors}t

## Extracted from my .Xdefaults; want to merge these colors into the terminal; TODO: Create a method/function to convert the #RRGGBB into an escapable character for strings!
#!--[Colours]--!
#! black
#URxvt*color0: #000000
#URxvt*color8: #999999
#
#! red
#URxvt*color1: #BD484A
#URxvt*color9: #F55D60
#
#! green
#!URxvt*color2: #66994E
#!URxvt*color10: #93DB6F
#
#! yellow
#URxvt*color3: #C4A043
#URxvt*color11: #F0C452
#
#! blue
#URxvt*color4: #567B94
#URxvt*color12: #7CB2D6
#
#! magenta
#URxvt*color5: #BB88DD
#URxvt*color13: #D7AFD7
#
#! cyan
#URxvt*color6: #00BBDD
#URxvt*color14: #0DEBFF
#
#! white
#URxvt*color7: #C7C7C7
#URxvt*color15: #D9D9D9
