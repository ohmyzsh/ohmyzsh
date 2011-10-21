# These three lines of simple code originally by ilikenwf/Matt Parnell
# simply import the ~/.aliases file if it exists when the plugin is
# enabled.

# By doing so, you can have custom aliases for various actions, without
# having to do something like push your aliases to github for security
# reasons, and for a nice simple divide.

# If you have a better place to put the .aliases file, or improvements,
# please put a pull request into my oh-my-zsh fork if you don't put it
# in the main oh-my-zsh repo.

# Example aliases:
# alias tunnel="ssh -D 3290  user@host.com"
# alias vnc="vncviewer -compresslevel 0 -q 0 localhost:2985"

if [ -f ~/.aliases ] ; then
	source ~/.aliases
fi
