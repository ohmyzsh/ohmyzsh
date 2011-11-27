# Smart sprunge alias/script.
#
# To add the sprunge script to your path, add this to your .zshrc file:
#
#   zstyle :omz:plugins:sprunge add-path on
#
# Otherwise, a simple alias for sprunge, but only if there isn't a smarter,
# better one out there in $PATH, will be added.

zstyle -b :omz:plugins:sprunge add-path _plugin__path
if [[ ${_plugin__path} == "on" ]]; then
  # Plugin setting: Add this plugin directory to the path
  export PATH=$PATH:$ZSH/plugins/sprunge
elif [ -z "${commands[sprunge]}" ]; then
  # Nope. No `sprunge` command, period. So, dumb/simple alias, here we go!
  alias sprunge="curl -F 'sprunge=<-' http://sprunge.us/"
fi
