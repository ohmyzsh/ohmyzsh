# web_search from terminal

function web_search() {
  # get the open command
  local open_cmd
  if [[ "$OSTYPE" = darwin* ]]; then
    open_cmd='open'
  else
    open_cmd='xdg-open'
  fi

  # check whether the search engine is supported
  if [[ ! $1 =~ '(google|bing|yahoo|duckduckgo)' ]];
  then
    echo "Search engine $1 not supported."
    return 1
  fi

  local url="${WEB_SEARCH_PROTOCOL:-https}://www.$1.${WEB_SEARCH_TLD:-com}"

  # no keyword provided, simply open the search engine homepage
  if [[ $# -le 1 ]]; then
    $open_cmd "$url"
    return
  fi
  #
  # slightly different search syntax for duckduckgo and yahoo
  if [[ $1 == 'duckduckgo' ]]; then
    url="${url}/?q="
  elif [[ $1 == 'yahoo' ]]; then
    url="${WEB_SEARCH_PROTOCOL:-https}://search.$1.com/search?p="
  else
    url="${url}/search?q="
  fi
  shift   # shift out $1

  while [[ $# -gt 0 ]]; do
    url="${url}$1+"
    shift
  done

  url="${url%?}" # remove the last '+'
  local error_file="$(mktemp -t websearchXXXX)"
  $open_cmd "$url" 2> ${error_file}
  echo $url
  local exit_code=$?
  if [[ ${exit_code} != 0 ]]; then
      cat $error_file 2>&1
  fi
  return ${exit_code}
}


alias bing='web_search bing'
alias google='web_search google'
alias yahoo='web_search yahoo'
alias ddg='web_search duckduckgo'
#add your own !bang searches here
alias wiki='web_search duckduckgo \!w'
alias news='web_search duckduckgo \!n'
alias youtube='web_search duckduckgo \!yt'
alias map='web_search duckduckgo \!m'
alias image='web_search duckduckgo \!i'
alias ducky='web_search duckduckgo \!'
