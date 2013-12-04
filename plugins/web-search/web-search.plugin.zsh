# web_search from terminal
# You can use the default browser to open the search, you can also choose to open
# the search browser, if you add in the parameter '-f' or '--firefox' will use firefox;
# Add the '-c' or '- chrome' will use of google-chrome

function web_search() {

  # get the open command
  local open_cmd firefox chrome

  for i in "$@"
    do
        if [[ $i =~ '(-f|--firefox)' ]];
        then
            firefox='true'
        elif [[ $i =~ '(-c|--chrome)' ]];
        then
            chrome='true'
        fi
    done
  if [[ $(uname -s) == 'Darwin' ]]; then
    open_cmd='open'
    [[ -n $firefox ]] && open_cmd='open  -a "/Applications/Firefox.app"'
    [[ -n $chrome ]] && open_cmd='open -a "/Applications/Google Chrome.app"'
  else
    open_cmd='xdg-open'
    [[ -n $firefox ]] && open_cmd='firefox'
    [[ -n $chrome ]] && open_cmd='google-chrome'
  fi

  # check whether the search engine is supported
  if [[ ! $1 =~ '(google|bing|yahoo|duckduckgo)' ]];
  then
    echo "Search engine $1 not supported."
    return 1
  fi

  local url="http://www.$1.com"

  # no keyword provided, simply open the search engine homepage
  if [[ $# -le 1 ]]; then
    eval $open_cmd "'$url'"
    return
  fi
  if [[ $1 == 'duckduckgo' ]]; then
  #slightly different search syntax for DDG
    url="${url}/?q="
  else
    url="${url}/search?q="
  fi
  shift   # shift out $1

  while [[ $# -gt 0 ]]; do
    if [[ ! $1 =~ '(-f|-c|--chrome|--firefox)' ]];
    then
        url="${url}$1+"
    fi
    shift
  done

  url="${url%?}" # remove the last '+'

  eval "$open_cmd" "'$url'"
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
