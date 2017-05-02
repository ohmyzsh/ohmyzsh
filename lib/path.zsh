# Appends to path arra in background to reduce load timey
# example
# path_push /usr/local
function path_push() {
  export PATH=$PATH:$1 &>/dev/null
}

# Prepends to path array in background to reduce load time
function path_unshift() {
  export PATH=$1:$PATH &>/dev/null
}
