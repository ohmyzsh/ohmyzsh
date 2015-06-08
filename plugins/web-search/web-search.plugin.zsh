# web_search from terminal

function web_search() {
  emulate -L zsh

  # define search engine URLS
  typeset -A urls
  urls=(
    google      "https://www.google.com/search?q="
    bing        "https://www.bing.com/search?q="
    yahoo       "https://search.yahoo.com/search?p="
    duckduckgo  "https://www.duckduckgo.com/?q="
    yandex      "https://yandex.ru/yandsearch?text="
  )

  # define the open command
  case "$OSTYPE" in
    darwin*)  open_cmd="open" ;;
    cygwin*)  open_cmd="cygstart" ;;
    linux*)   open_cmd="xdg-open" ;;
    *)        echo "Platform $OSTYPE not supported"
              return 1
              ;;
  esac

  # check whether the search engine is supported
  if [[ -z "$urls[$1]" ]]; then
    echo "Search engine $1 not supported."
    return 1
  fi

  # search or go to main page depending on number of arguments passed
  if [[ $# -gt 1 ]]; then
    # build search url:
    # join arguments passed with '+', then append to search engine URL
    url="${urls[$1]}${(j:+:)@[2,-1]}"
  else
    # build main page url:
    # split by '/', then rejoin protocol (1) and domain (2) parts with '//'
    url="${(j://:)${(s:/:)urls[$1]}[1,2]}"
  fi

  nohup $open_cmd "$url" &>/dev/null
}


alias bing='web_search bing'
alias google='web_search google'
alias yahoo='web_search yahoo'
alias ddg='web_search duckduckgo'
alias yandex='web_search yandex'

#add your own !bang searches here
alias wiki='web_search duckduckgo \!w'
alias news='web_search duckduckgo \!n'
alias youtube='web_search duckduckgo \!yt'
alias map='web_search duckduckgo \!m'
alias image='web_search duckduckgo \!i'
alias ducky='web_search duckduckgo \!'

#stackoverflow searches for common languages
alias soarduino='web_search duckduckgo \!so [arduino]'
alias sobash='web_search duckduckgo \!so [bash]'
alias soc='web_search duckduckgo \!so [c]'
alias soclojure='web_search duckduckgo \!so [clojure]'
alias socoffeescript='web_search duckduckgo \!so [coffeescript]'
alias socpp='web_search duckduckgo \!so [c++]'
alias socss='web_search duckduckgo \!so [css]'
alias sogo='web_search duckduckgo \!so [go]'
alias sohaskell='web_search duckduckgo \!so [haskell]'
alias sojava='web_search duckduckgo \!so [java]'
alias sojavascript='web_search duckduckgo \!so [javascript]'
alias solua='web_search duckduckgo \!so [lua]'
alias somatlab='web_search duckduckgo \!so [matlab]'
alias soperl='web_search duckduckgo \!so [perl]'
alias sophp='web_search duckduckgo \!so [php]'
alias sopython='web_search duckduckgo \!so [python]'
alias sor='web_search duckduckgo \!so [r]'
alias soruby='web_search duckduckgo \!so [ruby]'
alias sorust='web_search duckduckgo \!so [rust]'
alias soscala='web_search duckduckgo \!so [scala]'
alias soshell='web_search duckduckgo \!so [shell]'
alias soswift='web_search duckduckgo \!so [swift]'
alias sotex='web_search duckduckgo \!so [tex]'
alias sozsh='web_search duckduckgo \!so [zsh]'
