Sprunge
=======

This plugin adds powerful sprunge functionality to zsh. The script
optionally requires pygments with python >= 2.7 and either xclip or
xsel. Pygments is used to detect what language you have uploaded. If
it is detected, the url will automatically append the url with an
appropriate with `?lang`. Xclip or xsel are used to copy the urls to
the primary and secondary clipboards.

Usage
-----

You can call `sprunge` in any of the following ways:

	sprunge [files]
	sprunge < file
	piped_data | sprunge

Copyright & License
-------------------

This plugin is released under the MIT license. The script is presumed
to be released into the public domain, as the original announcement
had no explicit announcement.
