#!/usr/bin/env zsh

# Verify if we can read the `/etc/grc.zsh` file for alias generation,
# and source that.
[[ ! -r /etc/grc.zsh ]] || source /etc/grc.zsh
