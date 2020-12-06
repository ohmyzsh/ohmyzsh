# Autocompletion for rclone.
#
# Docs: https://rclone.org/commands/rclone_genautocomplete_zsh/

if [ $commands[rclone] ]; then
  source <(rclone genautocomplete zsh /dev/stdout)
fi
