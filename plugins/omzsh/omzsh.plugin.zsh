# Point to location of theme and plugin dirs
PLUGINS=$ZSH/plugins
THEMES=$ZSH/themes

if [[ "$1" == "plugins" ]]; then
	ls $PLUGINS
elif [[ "$1" == "themes" ]]; then
	ls $THEMES
elif [[ "$1" == "--help" ]]; then
	echo "plugins-List available plugins \nthemes-List available themes"
else
	echo "Invalid option. Try '--help' for available options"
fi
