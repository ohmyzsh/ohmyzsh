#!/bin/zsh

# compile a string of coffeescript and print to output
cf () {
<<<<<<< HEAD
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
=======
  coffee -peb "$1"
}
# compile & copy to clipboard
cfc () {
  cf "$1" | clipcopy
}

# compile from clipboard & print
alias cfp='cf "$(clippaste)"'

# compile from clipboard and copy to clipboard
alias cfpc='cfp | clipcopy'
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
