# Find kamal binary (local ./bin/kamal or global)
function _kamal_command () {
  if [ -x "./bin/kamal" ]; then
    ./bin/kamal "$@"
  else
    command kamal "$@"
  fi
}

function which-kamal() {
  if [ -x "./bin/kamal" ]; then
    echo "Using local ./bin/kamal"
  else
    echo "Using global $(command -v kamal)"
  fi
}

# Use `_kamal_command`` function for `kamal` command
alias kamal='_kamal_command'

# Aliases
alias kad='kamal deploy'

# Hook up completion
compdef _kamal_command=kamal
