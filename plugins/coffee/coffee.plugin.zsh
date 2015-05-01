#!/bin/zsh

# compile a string of coffeescript and print to output
cf () {
  coffee -peb $1
}
# compile & copy to clipboard
cfc () {
  cf $1 | tail -n +2 | pbcopy
}

# compile from pasteboard & print
alias cfp='coffeeMe "$(pbpaste)"'
