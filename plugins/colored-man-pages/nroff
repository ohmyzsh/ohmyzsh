#!/bin/sh

# The whole point of this wrapper is to replace emboldening factor -u0 with
# -u1 under certain circumstances on Solaris.

if [ "$1,$2,$3" = "-u0,-Tlp,-man" ]; then
  shift
  exec /usr/bin/nroff -u1 "$@"
else
  # Some other invocation of nroff
  exec /usr/bin/nroff "$@"
fi
