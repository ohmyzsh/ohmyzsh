if which carton &> /dev/null
then
  source $(dirname $(which carton))/../etc/carton_completion.zsh
else
  print "zsh carton plugin: carton not found"
fi
