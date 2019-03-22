workspace=~/workspace
ide=code

alias ws="cd $workspace"

remember-passphrase-per-session() {
  # TODO: copy to clipboard for macos and linux instead, but don't automate
  echo "Add this at the first line in with the editor: AddKeysToAgent yes"
  read -s -k '?Press any key to continue.'
  $ide ~/.ssh/config
}
