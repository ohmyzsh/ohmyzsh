#!/bin/bash
if [ $# -lt 1 ]; then
  echo "Usage: $(basename $0) file ..."
  exit 1
fi
for fn in "$@"
do
  if [ -r "$fn" ] ; then
    [ -d "$fn" ] && { echo "$fn is a directory"; continue; }
    printf '\033]1337;File=name='`echo -n "$fn" | base64`";"
    wc -c "$fn" | awk '{printf "size=%d",$1}'
    printf ":"
    base64 < "$fn"
    printf '\a'
  else
    echo File $fn does not exist or is not readable.
  fi
done
