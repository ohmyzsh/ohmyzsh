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
  # use python to attempt to detect the syntax
  sprunge_syntax() {
#    echo "try:
#	from pygments.lexers import get_lexer_for_filename
#	print(get_lexer_for_filename('$1').aliases[0])
#except:
#	print('text')" | python
	  echo ${1##*.}
	}
else
  # if we happen to lack python, just report everything as text
  omz_log_msg "sprunge: syntax highlighting disabled since python isn't available"
  sprunge_syntax() { echo 'text' }
fi

sprunge() {
  local urls url file syntax

  urls=()

  if [[ $1 == '-h' || $1 == '--help' ]]; then
    # print usage information
    sprunge_usage
    return 0
  elif [[ ! -t 0 || $#argv -eq 0 ]]; then
    # read from stdin
    url=$(curl -s -F 'sprunge=<-' http://sprunge.us <& 0)
    urls=(${url//[[:space:]]})
    [[ -z $url ]] || echo "stdin\t$url" >> $OMZ/sprunge.log
  else
    # treat arguments as a list of files to upload
    for file in $@; do
      if [[ ! -f $file ]]; then
        echo "$file isn't a file" >&2
        continue
      fi

      syntax=$(sprunge_syntax $file)
      url=$(curl -s -F 'sprunge=<-' http://sprunge.us < $file)
      url=${url//[[:space:]]}
      [[ $syntax != text ]] && url=${url}?${syntax}

      [[ -z $url ]] || echo "$file\t$url" >> $OMZ/sprunge.log
      urls+=(${url})
    done
  fi

  # output each url on its own line
  for url in $urls
    echo $url

  # don't copy to clipboad if piped
  [[ -t 1 ]] && sendtoclip $urls
}
