#---oh-my-zsh plugin : task Autocomplete for Jake tool---
# Jake : https://github.com/mde/jake
# Warning : Jakefile should have the right case : Jakefile or jakefile
# Tested on : MacOSX 10.7 (Lion), Ubuntu 11.10
# Author : Alexandre Lacheze (@al3xstrat)
<<<<<<< HEAD
# Inspiration : http://weblog.rubyonrails.org/2006/3/9/fast-rake-task-completion-for-zsh 

function _jake () {
  if [ -f Jakefile ]||[ -f jakefile ]; then
=======
# Inspiration : https://weblog.rubyonrails.org/2006/3/9/fast-rake-task-completion-for-zsh

function _jake () {
  if [ -f Jakefile ] || [ -f jakefile ] || [ -f Jakefile.js ] || [ -f jakefile.js ]; then
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
    compadd `jake -T | cut -d " " -f 2 | sed -E "s/.\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"`
  fi
}

<<<<<<< HEAD
compdef _jake jake
=======
compdef _jake jake
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
