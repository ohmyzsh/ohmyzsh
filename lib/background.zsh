# Appends to path arra in background to reduce load timey
# example
# path_push /usr/local
function bg_source() {
  source $1 
}

