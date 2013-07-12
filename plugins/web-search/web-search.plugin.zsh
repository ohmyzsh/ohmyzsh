# web_search from terminal

function web_search() {

  # get the open command
  local open_cmd
  if [[ $(uname -s) == 'Darwin' ]]; then
    open_cmd='open'
  else
    open_cmd='xdg-open'
  fi

  local url="http://$1"

  # no keyword provided, simply open the search engine homepage
  if [[ ! $# -le 2 ]]; then
    url="${url}/$2"

    shift 2  # shift out $1 and $2

    while [[ $# -gt 0 ]]; do
      url="${url}$1+"
      shift
    done

    url="${url%?}" # remove the last '+'
  fi

  $open_cmd "$url" &> /dev/null
}

alias bing='web_search www.bing.com search\?q='
alias google='web_search www.google.com search\?q='
alias yahoo='web_search www.yahoo.com search\?q='
alias ddg="web_search www.duckduckgo.com \?q="
