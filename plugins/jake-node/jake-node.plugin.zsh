#---oh-my-zsh plugin : task Autocomplete for Jake tool---
# Jake : https://github.com/mde/jake
# Warning : Jakefile should have the right case : Jakefile or jakefile
# Tested on : MacOSX 10.7 (Lion), Ubuntu 11.10
# Author : Alexandre Lacheze (@al3xstrat)
# Inspiration : http://weblog.rubyonrails.org/2006/3/9/fast-rake-task-completion-for-zsh 

function _jake () {
  if [ -f Jakefile ]||[ -f jakefile ]; then
    compadd `jake -T | cut -d " " -f 2 | sed -E "s/.\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"`
  fi
}

compdef _jake jake