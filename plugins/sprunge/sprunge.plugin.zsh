# Smart sprunge alias/script.
#
# Contributed and SLIGHTLY modded by Matt Parnell/ilikenwf <parwok -at- gmail>
# Created by the blogger at the URL below...I don't know where to find his/her name
# Original found at http://www.shellperson.net/sprunge-pastebin-script/

sprunge_usage() {
  cat << HERE

DESCRIPTION
  Upload data and fetch URL from the pastebin http://sprunge.us

  In addition to printing the returned URL, if the xset or xsel
  programs are available (on $PATH), the URL will also be copied to the
  PRIMARY selection and the CLIPBOARD selection (allowing to quickly
  paste the url into IRC client for example).

USAGE
  $0 filename.txt
  $0 < filename.txt
  piped_data | $0

INPUT METHODS
  $0 can accept piped data, STDIN redirection [<filename.txt], text strings
  following the command as arguments, or filenames as arguments.  Only one
  of these methods can be used at a time, so please see the note on
  precedence.  Also, note that using a pipe or STDIN redirection will treat
  tabs as spaces, or disregard them entirely (if they appear at the
  beginning of a line).  So I suggest using a filename as an argument if
  tabs are important either to the function or readability of the code.

PRECEDENCE
  STDIN redirection has precedence, then piped input, then a filename as an
  argument. Example:

      echo piped | "$0" arguments.txt < stdin_redirection.txt

  In this example, the contents of file_as_stdin_redirection.txt would be
  uploaded. Both the piped_text and the file_as_argument.txt are ignored. If
  there is piped input and arguments, the arguments will be ignored, and the
  piped input uploaded.

FILENAMES
  If a filename is misspelled or doesn't have the necessary path
  description, it will NOT generate an error, but will instead treat it as
  a text string and upload it.

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

  if [[ ! -t 0 ]]; then
    url=$(curl -s -F 'sprunge=<-' http://sprunge.us <& 0)
    urls=(${url//[[:space:]]})
  elif [[ $#argv -eq 0 ]]; then
    sprunge_usage
    return 1
  else
    # Use python to attempt to detect the syntax
    for file in $@; do
      if [[ ! -f $file ]]; then
        echo "$file isn't a file"
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

  #copy url to primary and clipboard (middle-mouse & shift+ins/Ctrl+v)
  if (( $+commands[xclip] )); then
    echo -n $urls | xclip -sel primary
    echo -n $urls | xclip -sel clipboard
  elif (( $+commands[xsel] )); then
    echo -n $urls | xsel -ip # primary
    echo -n $urls | xsel -ib # clipboard
  fi
}
