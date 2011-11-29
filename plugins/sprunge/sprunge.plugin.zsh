# Smart sprunge alias/script.
#
# Contributed and SLIGHTLY modded by Matt Parnell/ilikenwf <parwok -at- gmail>
# Created by the blogger at the URL below...I don't know where to find his/her name
# Original found at http://www.shellperson.net/sprunge-pastebin-script/

sprunge_usage() {
  cat << HERE
Usage:
  sprunge [files]
  sprunge < file
  piped_data | sprunge

Upload data and fetch URL from the pastebin http://sprunge.us.
HERE
}

if (( $+commands[python] )); then
  sprunge_syntax() {
    echo "try:
	from pygments.lexers import get_lexer_for_filename
	print(get_lexer_for_filename('$1').aliases[0])
except:
	print('text')" | python
  }
else
  sprunge_syntax() { echo 'text' }
fi

sprunge() {
  local urls url file syntax

  urls=()

  if [[ ! -t 0 || $#argv -eq 0 ]]; then
    url=$(curl -s -F 'sprunge=<-' http://sprunge.us <& 0)
    urls=(${url//[[:space:]]})
  elif [[ $1 == '-h' || $1 == '--help' ]]; then
    sprunge_usage
    return 0
  else
    # Use python to attempt to detect the syntax
    for file in $@; do
      if [[ ! -f $file ]]; then
        echo "$file isn't a file" >&2
        continue
      fi

      syntax=$(sprunge_syntax $file)
      url=$(curl -s -F 'sprunge=<-' http://sprunge.us < $file)
      url=${url//[[:space:]]}
      [[ $syntax != text ]] && url=${url}?${syntax}

      urls+=(${url})
    done
  fi

  # output
  for url in $urls
    echo $url

  # don't copy to clipboad if piped
  [[ ! -t 1 ]] && return 0

  # copy urls to primary and clipboard (middle-mouse & shift+ins/Ctrl+v)
  if (( $+commands[xclip] )); then
    echo -n $urls | xclip -sel primary
    echo -n $urls | xclip -sel clipboard
  elif (( $+commands[xsel] )); then
    echo -n $urls | xsel -ip # primary
    echo -n $urls | xsel -ib # clipboard
  fi
}
