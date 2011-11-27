# A simple alias for sprunge, but only if there isn't a smarter, better one out
# there in $PATH
#
# A good one to add is the sprunge script in this directory.

if [ -z "${commands[sprunge]}" ]; then
  alias sprunge="curl -F 'sprunge=<-' http://sprunge.us/"
fi
