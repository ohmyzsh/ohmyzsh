#!/bin/zsh

################################################################################
# This function shows the current weather info of the location passed
# by argument (your current location if no location is passed).
# e.g.: weather
# e.g.: weather Madrid
################################################################################
function weather {
  command -v 'curl' > /dev/null 2>&1 && \
    curl "wttr.in/$1" -s | head -n 7
}
