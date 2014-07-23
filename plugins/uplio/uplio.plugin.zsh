# Copied from https://gist.github.com/henrique2010/4a474e036f2f1a7de96f by @henrique2010
# This command receives a file as param, upload it to upl.io and copy the url to the clipboard
#
# dependencies: curl and (xclip or pbcopy)
# example: $ upload ~/Images/image.png

uplio() {
  echo 'Uploading...'
  url=`curl http://upl.io -F file=@$1 -s`
  if command -v pbcopy >/dev/null; then
    echo -n $url | pbcopy
  elif command -v xclip >/dev/null; then
    echo -n $url | xclip -sel clip
  else
    echo 'You need either pbcopy or xclip to copy the url to clipboard'
  fi
  echo $url
}
