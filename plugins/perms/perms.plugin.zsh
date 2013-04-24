# https://gneatgeek.github.io
#
# Some useful commands for setting permissions. I find this most handy for website files.

### Aliases

# Set all files' permissions to 644 recursively in a directory
alias set644='find -type f -exec chmod 644 {} \;'
 
# Set all directories' permissions to 755 recursively in a directory
alias set755='find -type d -exec chmod 755 {} \;'

### Functions

# fixperms - useful combination of the above two aliases. Will apply to supplied dir or current dir.
fixperms () {
  if [ "${#}" -gt "1" -o  "${1}" = "--help" ]; then
    echo "Usage: fixperms [source]"
  else
    confirm=""
    while [ "${confirm}" = "" -o "${confirm}" = "y" ]; do
      if [ -d "${1}" ]; then
        if [ "${confirm}" = "" ]; then
          echo "Fixing perms on ${1}?"
        else
          find "${1}" -type f -exec chmod 644 {} \;
          find "${1}" -type d -exec chmod 755 {} \;
        fi
      else
        if [ "${confirm}" = "" ]; then
          echo "Fixing perms on ${PWD##*/}?"
        else
          find -type f -exec chmod 644 {} \;
          find -type d -exec chmod 755 {} \;
        fi
      fi
      if [ "${confirm}" = "" ]; then
        echo "Proceed? (y|n) "
        read confirm
      else
        echo "Complete"
        confirm=n
      fi
    done
  fi
}

