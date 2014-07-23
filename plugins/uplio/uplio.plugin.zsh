# Copied from https://gist.github.com/henrique2010/4a474e036f2f1a7de96f by @henrique2010
# This command receives a file as param, upload it to upl.io and copy the url to the clipboard
#
# install: copy this code to your .bashrc or .zshrc
# dependencies: curl and xclip
# example: $ upload ~/Images/image.png

uplio() {
  echo 'Uploading...'
  url=`curl http://upl.io -F file=@$1 -s`
  echo -n $url | pbcopy
  echo $url
}
