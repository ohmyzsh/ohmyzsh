Tmux
====

DESCRIPTION TO GO HERE

Configuration
-------------

To set a corresponding command to a session name, set a zstyle like
this

	zstyle :omz:plugins:tmux:cmd irc weechat-curses

This setups up the tmux plugin to start or jump to weechat when `t
irc` is executed.

The plugin can be configured to start tmux with zsh. To do so, set
this zstyle appropriately. If so, it's ideal to have tmux first in the
plugin array

	zstyle :omz:plugins:tmux autostart on

Usage
-----

You can call the `t` function in two ways:

	t session
	t session command

Copyright & License
-------------------

This plugin is released under the GLP3
