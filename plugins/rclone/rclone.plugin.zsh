# Autocompletion for rclone.
#
# Docs: https://rclone.org/commands/rclone_genautocomplete_zsh/

if [ $commands[rclone] ]; then
  source <(rclone genautocomplete zsh /tmp/rclone-plugin.$$ && cat /tmp/rclone-plugin.$$)
  rm /tmp/rclone-plugin.$$
fi
