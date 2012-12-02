# URL Tools
# Adds handy command line aliases useful for dealing with URLs
#
# Taken from:
# http://ruslanspivak.com/2010/06/02/urlencode-and-urldecode-from-a-command-line/

alias urlencode='node -e "console.log(encodeURIComponent(process.argv[1]))"'

alias urldecode='node -e "console.log(decodeURIComponent(process.argv[1]))"'
