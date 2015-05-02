#!/bin/zsh

# compile a string of coffeescript and print to output
cf () {
  coffee -peb $1
}
# compile & copy to clipboard
cfc () {
  cf $1 | pbcopy
}

# compile from pasteboard & print
alias cfp='coffeeMe "$(pbpaste)"'

# compile from pasteboard and copy to clipboard
alias cfpc='cfp | pbcopy'
