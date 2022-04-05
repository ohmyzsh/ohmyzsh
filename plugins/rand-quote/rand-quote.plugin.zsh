<<<<<<< HEAD
# Get a random quote fron the site http://www.quotationspage.com/random.php3
# Created by Eduardo San Martin Morote aka Posva
# http://posva.github.io
# Sun Jun 09 10:59:36 CEST 2013 
# Don't remove this header, thank you
# Usage: quote

WHO_COLOR="\e[0;33m"
TEXT_COLOR="\e[0;35m"
COLON_COLOR="\e[0;35m"
END_COLOR="\e[m"

if [[ -x `which curl` ]]; then
    function quote()
    {
        Q=$(curl -s --connect-timeout 2 "http://www.quotationspage.com/random.php3" | iconv -c -f ISO-8859-1 -t UTF-8 | grep -m 1 "dt ")
        TXT=$(echo "$Q" | sed -e 's/<\/dt>.*//g' -e 's/.*html//g' -e 's/^[^a-zA-Z]*//' -e 's/<\/a..*$//g')
        W=$(echo "$Q" | sed -e 's/.*\/quotes\///g' -e 's/<.*//g' -e 's/.*">//g')
        if [ "$W" -a "$TXT" ]; then
          echo "${WHO_COLOR}${W}${COLON_COLOR}: ${TEXT_COLOR}“${TXT}”${END_COLOR}"
        else
          quote
        fi
    }
    #quote
else
    echo "rand-quote plugin needs curl to work" >&2
fi
=======
if ! (( $+commands[curl] )); then
  echo "rand-quote plugin needs curl to work" >&2
  return
fi

function quote {
  setopt localoptions nopromptsubst

  # Get random quote data
  local data
  data="$(command curl -s --connect-timeout 2 "http://www.quotationspage.com/random.php" \
    | iconv -c -f ISO-8859-1 -t UTF-8 \
    | command grep -a -m 1 'dt class="quote"')"

  # Exit if could not fetch random quote
  [[ -n "$data" ]] || return 0

  local quote author
  quote=$(sed -e 's|</dt>.*||g' -e 's|.*html||g' -e 's|^[^a-zA-Z]*||' -e 's|</a..*$||g' <<< "$data")
  author=$(sed -e 's|.*/quotes/||g' -e 's|<.*||g' -e 's|.*">||g' <<< "$data")

  print -P "%F{3}${author}%f: “%F{5}${quote}%f”"
}
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
