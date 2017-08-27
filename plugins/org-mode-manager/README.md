# org-mode-manager

This plugin defines a function `org` that provides a tree-like representation of [org-mode](http://orgmode.org/) files in a user configured directory.

#### Usage:

     org <file> [--remove]

#### Example usage:

     org tulip
	 # tulip.org is created
	 #
	 org banana --remove
	 # banana.org is removed
	 #
	 org flowers/colorful/tulip
	 # tulip.org is created at path flowers/colorful
	 # in the user directory
	 #

The `.org` extension is automatically added if not specified.
