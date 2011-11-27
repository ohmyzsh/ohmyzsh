# sprunge alias

This plugin adds at least an alias to zsh. However, you can use the smarter
script, provided as part of the plugin, instead. To enable it, add the following
to your `.zshrc`:

    zstyle :omz:plugins:sprunge add-path on

The plugin will modify your path, adding `$ZSH/plugins/sprunge` to the end of
it. This plugin presumes you set `$ZSH` to the directory where oh-my-zsh is
installed to. This is the default if you used the template zshrc.

# Note

The plugin does not overwrite anything. If you had an alias, or there is another
binary in your system that is called 'sprunge', this plugin will do **nothing**.

The script also depends on pygments, and python >= 2.7. Pygments is used to
detect what language you have uploaded. If it is detected, the url will
automatically be appended with `?lang`, where 'lang' is language.

## Usage

If you let the plugin add the sprunge script to your $PATH, you can call
`sprunge` in any of the following ways:

    sprunge filename.txt
    sprunge < filename.txt
    piped_data | sprunge

Otherwise, the alias defined by the script can only be called the following way:

    piped_data | sprunge

# Copyright, license, etc.

This plugin is released under the MIT license. The script is presumed to be
released into the public domain, as the original announcement had no explicit
announcement.
