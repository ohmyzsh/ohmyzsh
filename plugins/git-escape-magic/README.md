# Git Escape Magic

This plugin is copied from the original at
https://github.com/knu/zsh-git-escape-magic. All credit for the
functionality enabled by this plugin should go to @knu.

An excerpt from that project's readme explains it's purpose.

> It eliminates the need for manually escaping those meta-characters. The zle function it provides is context aware and recognizes the characteristics of each subcommand of git. Every time you type one of these meta-characters on a git command line, it automatically escapes the meta-character with a backslash as necessary and as appropriate.

## Useage

To use this plugin add it to your list of plugins in your `.zshrc` file.

**NOTE**: If you use url-quote-magic it must be included before this
plugin runs to prevent any conflicts.

