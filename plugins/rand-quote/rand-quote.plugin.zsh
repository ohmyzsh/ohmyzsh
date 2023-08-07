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
