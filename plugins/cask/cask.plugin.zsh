if which cask &> /dev/null; then
  source $(dirname $(which cask))/../etc/cask_completion.zsh
else
  print "zsh cask plugin: cask not found"
fi
