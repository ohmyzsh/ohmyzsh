# web_search from terminal

function web_search() {

  # get the open command
  local open_cmd
  if [[ $(uname -s) == 'Darwin' ]]; then
    open_cmd='open'
  else
    open_cmd='xdg-open'
  fi

  # check whether the search engine is supported
  if [[ ! $1 =~ '(google|bing|yahoo|yandex)' ]];
  then
    echo "Search engine $1 not supported."
    return 1
  fi

  if [[ $1 =~ '(google|bing|yahoo)' ]];
  then
    local url="http://www.$1.com"
  elif [[ $1 == 'yandex' ]];
  then
      local url="http://$1.ru"
  fi

  # no keyword provided, simply open the search engine homepage
  if [[ $# -le 1 ]]; then
    $open_cmd "$url"
    return
  fi

  if [[ $1 =~ '(google|bing|yahoo)' ]];
  then
    url="${url}/search?q="
  elif [[ $1 == 'yandex' ]];
  then
    url="${url}/yandsearch?text="
  fi

  shift   # shift out $1

  while [[ $# -gt 0 ]]; do
    url="${url}$1+"
    shift
  done

  url="${url%?}" # remove the last '+'

  $open_cmd "$url"
}

alias bing='web_search bing'
alias google='web_search google'
alias yahoo='web_search yahoo'
alias yandex='web_search yandex'
alias ya='web_search yandex'

