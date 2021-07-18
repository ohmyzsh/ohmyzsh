#!/usr/bin/env zsh

#
# tilde-switch-zsh
#
# This key binding plugin gets tilde key back on MacOS 
# Swithes back ± key to ~ 
#
# Copyright(c) 2021 Mevlut Canvar <mevlutcanvar@gmail.com>
# MIT Licensed
#

#
# Mevlüt Canvar
# GitHub: https://github.com/mcanvar
# Twitter: https://twitter.com/mevlutcanvar
#

#
# This solution taken from here: https://apple.stackexchange.com/a/353941
#

MAPPING=$(cat <<EOF
{
   "UserKeyMapping":[
      {
         "HIDKeyboardModifierMappingSrc":0x700000035,
         "HIDKeyboardModifierMappingDst":0x700000064
      },
      {
         "HIDKeyboardModifierMappingSrc":0x700000064,
         "HIDKeyboardModifierMappingDst":0x700000035
      }
   ]
}
EOF
)

hidutil property --set $MAPPING > /dev/null
