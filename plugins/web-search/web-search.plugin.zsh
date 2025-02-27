# web_search from terminal

function web_search() {
  emulate -L zsh

  # define search engine URLS
  typeset -A urls
  urls=(
    $ZSH_WEB_SEARCH_ENGINES
    google          "https://www.google.com/search?q="
    bing            "https://www.bing.com/search?q="
    brave           "https://search.brave.com/search?q="
    yahoo           "https://search.yahoo.com/search?p="
    duckduckgo      "https://www.duckduckgo.com/?q="
    startpage       "https://www.startpage.com/do/search?q="
    yandex          "https://yandex.ru/yandsearch?text="
    github          "https://github.com/search?q="
    baidu           "https://www.baidu.com/s?wd="
    ecosia          "https://www.ecosia.org/search?q="
    goodreads       "https://www.goodreads.com/search?q="
    qwant           "https://www.qwant.com/?q="
    givero          "https://www.givero.com/search?q="
    stackoverflow   "https://stackoverflow.com/search?q="
    wolframalpha    "https://www.wolframalpha.com/input/?i="
    archive         "https://web.archive.org/web/*/"
    scholar         "https://scholar.google.com/scholar?q="
    ask             "https://www.ask.com/web?q="
    youtube         "https://www.youtube.com/results?search_query="
    deepl           "https://www.deepl.com/translator#auto/auto/"
    dockerhub       "https://hub.docker.com/search?q="
    npmpkg          "https://www.npmjs.com/search?q="
    packagist       "https://packagist.org/?query="
    gopkg           "https://pkg.go.dev/search?m=package&q="
    chatgpt         "https://chatgpt.com/?q="
    # for the new reddit search go below at row 67
    ppai            "https://www.perplexity.ai/search/new?q="
  )

  # check whether the search engine is supported
  if [[ -z "$urls[$1]" ]]; then
    echo "Search engine '$1' not supported."
    return 1
  fi

  # search or go to main page depending on number of arguments passed
  if [[ $# -gt 1 ]]; then
    # if search goes in the query string ==> space as +, otherwise %20
    # see https://stackoverflow.com/questions/1634271/url-encoding-the-space-character-or-20
    local param="-P"
    [[ "$urls[$1]" == *\?*= ]] && param=""

    # build search url:
    # join arguments passed with '+', then append to search engine URL
    url="${urls[$1]}$(omz_urlencode $param ${(s: :)@[2,-1]})"
  else
    # build main page url:
    # split by '/', then rejoin protocol (1) and domain (2) parts with '//'
    url="${(j://:)${(s:/:)urls[$1]}[1,2]}"
  fi

  open_command "$url"
}

# example usage: reddit swaywm (search all subreddits for swaywm)
# example usage: reddit --sr unixporn swaywm (search only unixporn subreddit for swaywm) -> https://www.reddit.com/r/unixporn/search?q=swaywm

function reddit_search() {
    emulate -L zsh
    local url="https://www.reddit.com"
    local query=""
    local subreddit=""
    
    # if the user pass "--sr <subreddit name>" as first argument
    # then the second argument is the subreddit name
    if [[ "$1" == "--sr" ]]; then
        subreddit="$2"
        query="${@[3,-1]}"
    else
        query="${@[1,-1]}"
    fi
    
    # if query is empty, remove the search query
    if [[ -z "$query" ]]; then
        query=""
    fi
    
    # if subreddit is empty, search all subreddits
    # but if query is empty, remove the search query
    if [[ -z "$subreddit" ]]; then
        if [[ -z "$query" ]]; then
            url="$url"
        else
            url="$url/search?q=$(omz_urlencode -P $query)"
        fi
        
    else
        # if subreddit is not empty, search only that subreddit
        if [[ -z "$query" ]]; then
            url="$url/r/$subreddit"
        else
            url="$url/r/$subreddit/search?q=$(omz_urlencode -P $query)"
        fi
    fi
    
    open_command "$url"
}


alias bing='web_search bing'
alias brs='web_search brave'
alias google='web_search google'
alias yahoo='web_search yahoo'
alias ddg='web_search duckduckgo'
alias sp='web_search startpage'
alias yandex='web_search yandex'
alias github='web_search github'
alias baidu='web_search baidu'
alias ecosia='web_search ecosia'
alias goodreads='web_search goodreads'
alias qwant='web_search qwant'
alias givero='web_search givero'
alias stackoverflow='web_search stackoverflow'
alias wolframalpha='web_search wolframalpha'
alias archive='web_search archive'
alias scholar='web_search scholar'
alias ask='web_search ask'
alias youtube='web_search youtube'
alias deepl='web_search deepl'
alias dockerhub='web_search dockerhub'
alias npmpkg='web_search npmpkg'
alias packagist='web_search packagist'
alias gopkg='web_search gopkg'
alias chatgpt='web_search chatgpt'
alias reddit='reddit_search'
alias ppai='web_search ppai'

#add your own !bang searches here
alias wiki='web_search duckduckgo \!w'
alias news='web_search duckduckgo \!n'
alias map='web_search duckduckgo \!m'
alias image='web_search duckduckgo \!i'
alias ducky='web_search duckduckgo \!'

# other search engine aliases
if [[ ${#ZSH_WEB_SEARCH_ENGINES} -gt 0 ]]; then
  typeset -A engines
  engines=($ZSH_WEB_SEARCH_ENGINES)
  for key in ${(k)engines}; do
    alias "$key"="web_search $key"
  done
  unset engines key
fi
